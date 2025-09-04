# Velociraptor Docker Image

Unofficial Docker image for [Velociraptor](https://github.com/Velocidex/velociraptor) by Velocidex.

# What is Velociraptor?

Velociraptor is an advanced digital forensic and incident response tool that enhances your visibility into your endpoints.

Visit [velociraptor official docs](https://docs.velociraptor.app/) for more information.

# How to use this image

## Quickstart

Run the container in detached mode with the default configuration.  
This exposes the following ports:

- **8889** – Web UI  
- **8000** – Agent port  
- **8001** – API  

```bash
docker run -d --name velociraptor \
  -p 8000:8000 \
  -p 8001:8001 \
  -p 8889:8889 \
  zharfanug/velociraptor:0.75.1
```

# Environment

The image sets the following defaults:
| Variable        | Default                       | Purpose                                                                 |
|-----------------|-------------------------------|-------------------------------------------------------------------------|
| `VELO_CERT`     | auto-generated self-signed    | Path to the TLS certificate used by the server. If omitted, a self-signed certificate is generated. |
| `VELO_CERT_KEY` | auto-generated key            | Path to the TLS private key. Must match `VELO_CERT`. If omitted, a key is generated. |
| `VELO_FQDN`     | `https://$HOSTNAME:8000/`     | Public URL advertised to clients. Set this to the externally reachable hostname and port of the server. |
| `VELO_USER`     | `admin`                       | Initial administrator username for the web UI. |
| `VELO_PASSWORD` | `admin`                       | Initial administrator password. Change immediately in production. |
