# Julia Installation and Package Management Test Report

## Summary

Julia (via juliaup) was successfully installed. The domain `*.julialang.org` **IS** whitelisted in the proxy, but Julia's package manager still fails due to a proxy connection reuse issue. Julia's HTTP client makes multiple CONNECT tunnel requests, and while the first succeeds, subsequent requests fail with `x-deny-reason: host_not_allowed`.

## Installation Details

### Juliaup Installation
- **Status**: SUCCESS
- **Method**: curl -fsSL https://install.julialang.org | sh
- **Version Installed**: Julia 1.12.1+0.x64.linux.gnu
- **Installation Path**: /root/.juliaup/
- **Binary Path**: /root/.juliaup/bin

### Julia Verification
- **Command**: julia --version
- **Output**: julia version 1.12.1
- **Status**: SUCCESS

### Package Installation Test
- **Command**: julia -e 'using Pkg; Pkg.add("JSON")'
- **Status**: FAILED
- **Error**: HTTP/1.1 403 Forbidden (CONNECT tunnel failed, response 403)

## Network Requirements for Julia Package Management

To enable Julia package installation, the following domains need to be whitelisted:

### Primary Domain
- **pkg.julialang.org** - Julia's package registry server
  - Full URL encountered: https://pkg.julialang.org/registry/23338594-aafe-5451-b93e-139f81909106/8548b960665ed34ff81507edf35ace83d3225877

### Additional Domains (Likely Required)
- **github.com** - Most Julia packages are hosted on GitHub
- **githubusercontent.com** - Raw content from GitHub repositories
- **juliahub.com** - Alternative package hosting

### Network Access Type
- **HTTPS (port 443)** - Required for secure package downloads
- **Issue**: CONNECT tunnel is being blocked, causing 403 Forbidden errors

## Root Cause Analysis

### The Issue
The domain `*.julialang.org` **is correctly whitelisted** in the proxy's JWT token. However, Julia's Downloads.jl (which uses libcurl) makes **multiple CONNECT tunnel requests** during a single download operation, and the proxy rejects subsequent requests after the first succeeds.

### Observed Behavior

**With curl (works correctly):**
```
> CONNECT pkg.julialang.org:443 HTTP/1.1
< HTTP/1.1 200 OK
* CONNECT tunnel established, response 200
[TLS handshake proceeds successfully]
```

**With Julia Downloads.jl (fails):**
```
First request:
> CONNECT pkg.julialang.org:443 HTTP/1.1
< HTTP/1.1 200 OK
* CONNECT tunnel established, response 200

Second request (same connection):
> CONNECT pkg.julialang.org:443 HTTP/1.1
< HTTP/1.1 403 Forbidden
< x-deny-reason: host_not_allowed
* CONNECT tunnel failed, response 403
```

### User-Agent Difference
- curl: `User-Agent: curl/8.5.0`
- Julia: `User-Agent: curl/8.11.1 julia/1.12`

### Error Details

The package manager attempts to:
1. Download the Julia package registry from pkg.julialang.org
2. Access package metadata and source files
3. Install packages and their dependencies

The error occurs at step 1 when Julia's HTTP client attempts to reuse or re-establish the CONNECT tunnel:
```
ERROR: could not download https://pkg.julialang.org/registry/...
Exception: RequestError: HTTP/1.1 403 Forbidden (CONNECT tunnel failed, response 403)
Headers: x-deny-reason: host_not_allowed
```

## Recommendations

The domain `*.julialang.org` is already whitelisted. The issue is with the proxy's handling of multiple CONNECT tunnel requests from the same client. To fix this:

1. **Update proxy configuration** to allow multiple CONNECT requests to the same whitelisted host within a single session/connection
2. **Alternative**: Configure the proxy to not reject connection reuse or re-authentication attempts for already-whitelisted domains
3. **Verify**: The proxy JWT token already contains `*.julialang.org` in the `allowed_hosts` field

### Additional Domains for Full Julia Package Management
Once the proxy connection reuse issue is resolved, you'll also need:
1. **github.com** (HTTPS/443) - Required for package sources
2. **raw.githubusercontent.com** or **githubusercontent.com** (HTTPS/443) - Required for downloading package files

## Test Commands for Verification

Once the proxy connection reuse issue is resolved, test with:
```bash
# Test basic package addition
julia -e 'using Pkg; Pkg.add("JSON")'

# Test package status
julia -e 'using Pkg; Pkg.status()'

# Test using a package
julia -e 'using JSON; println(JSON.parse("{\"test\": 42}"))'
```
