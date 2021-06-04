# nginx-live

nginx-live is a simple, lightweight, self-hosted video streaming service in a Docker container.  
It allows you to securely stream video and audio from encoders such as OBS via RTMP or RTMPS. The stream is then converted to the HLS format so that it can be viewed by a larger number of viewers in their favorite browser.

## Usage

### Simple / Development Setup

If you want to try nginx-live, or test a configuration change, you can start the container without any environment variables. In this case the ingest is done unencrypted via RTMP. The necessary stream key is generated randomly and printed in the Docker log during the first start.

```shell
docker run -d --name streaming -p 8080:8080 -p 1935:1935 repo.bluemedia.dev/bluemedia/nginx-live
```

After launch, the web player should be available at `http://<hostname-or-ip>:8080/`.  
If you want to stream, you have to set `rtmp://<hostname-or-ip>/live` as the server in your streaming software. The stream key can be found in the log of the container. Other encoder / streaming software should be configurable similarly. If your software has no extra field for the stream key, you can simply append it to the server url: `rtmp://<hostname-or-ip>/live/<stream-key>`.

### Production Setup

If you want to use the container in production, e.g. as a streaming server on the internet, you should adjust some settings. The following configuration enables TLS encrypted ingest. In order to do this, TLS certificates are required, these can be obtained e.g. from Let's Encrypt. Mount your PEM encoded certificate to the /cert directory inside the container and specify the filenames of the certificate and the private key in the two `TLS_*` environment variables.

```shell
docker run -d --name streaming -p 8080:8080 -p 1935:1935 \
-v /path/to/certs:/cert:ro \
-e TLS_CERT=fullchain.cer \
-e TLS_KEY=private.key \
repo.bluemedia.dev/bluemedia/nginx-live
```

You will now need to set the server url in your streaming software in the following format: `rtmps://<hostname-or-ip>:<rtmp-port>/live`. It is important that you specify the RTMP port.  

If you want to make the web player and the HLS files available via HTTPS, you can simply put a reverse proxy of your choice in front of the nginx-live container.

### Available environment variables
- `RTMP_PORT` - Port on which nginx-live listens for ingest data from your streaming software or encoder. Defaults to `1935`.
- `HTTP_PORT` - Port on which the web player and HLS files are available via HTTP. Defaults to `8080`.
- `TLS_CERT` - File name of the TLS certificate file in the /cert directory inside the container. If set, encrypted ingest will be enabled on the RTMP port.
- `TLS_KEY` - File name of the private key that belongs to the TLS certificate.
- `STREAM_KEY` - Stream key, which is needed to ingest stream data. If the variable is not set, the key is randomly generated at container startup.
- `HLS_FRAGMENT_LENGTH` - Length of one HLS fragment in seconds. Defaults to `3`.
- `HLS_PLAYLIST_LENGTH` - Length of the HLS playlist in seconds. Defaults to `20`.

## Built with
- [NGINX](https://www.nginx.com/) High Performance Load Balancer, Web Server, & Reverse Proxy
- [nginx-rtmp-module](https://github.com/arut/nginx-rtmp-module) NGINX-based Media Streaming Server
- [voc-player](https://github.com/voc/voc-player) HTML5 Stream Player for MPEG-DASH and HLS

## Project structure / Directories
- `config/` NGINX config files with various placeholders which will be replaced by the entrypoint script.
- `frontend/` All frontend related files. These will be copied to the web root of nginx.

## Automated image builds
The Docker image `repo.bluemedia.dev/bluemedia/nginx-live` is built an pushed every two days by a Jenkins instance. Builds are based on the current main branch of this repository.

## Contribution Guidelines

- Use 4 spaces indent
- Always leave enough empty lines in bigger code blocks
- Comment your code (in english)
- Stick to the structure
- Test your changes
- Update the documentation
