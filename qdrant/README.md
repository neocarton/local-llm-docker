# Code-LLM Project

## Troubleshooting

### Qdrant Filesystem Check Error

- **Issue**: Filesystem check failed for storage path ./storage. Details: Unrecognized filesystem - cannot guarantee data safety.
- **Cause**: Qdrant requires a POSIX‑compatible filesystem. Mounting host folders from non‑POSIX filesystems (e.g., Windows, network share) can trigger this error.
- **Solution**: Use a Docker named volume instead of a host bind mount.
