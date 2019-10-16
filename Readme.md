# Varnish Docker image including vmods

The [official Varnish Docker image](https://hub.docker.com/_/varnish) does not
include any of it's [extensions/varnish
modules/vmods](https://github.com/varnish/varnish-modules). To make matters
worse, Varnish does not ship vmod binaries for the open source version, so
putting everything together is a fiddly task for which there is scarse
documentation.

This repo contains a Dockerfile that builds Varnish at a version of your
choosing with all the vmods included. There is even [a Dockerhub
repo](https://hub.docker.com/r/cjohansen/varnish-vmods) for your convenience.

## How to use it

In your `default.vcl`:

```vcl
vcl 4.0;
import cookie from "/usr/local/lib/varnish/vmods/libvmod_cookie.so";

sub vcl_recv {
  # Ensure that an A/B test cookie is set
  if (cookie.get("abgroup")) {
    set req.http.abgroup = cookie.get("abgroup");
  } else {
    if (std.random(0, 99) < 50) {
      set req.http.abgroup = "A";
    } else {
      set req.http.abgroup = "B";
    }
  }

  # ...
}
```

Run the Docker container:

```sh
docker run \
    -v path/to/config:/etc/varnish \
    -e "VCL_CONFIG=/etc/varnish/default.vcl" \
    -p 8090:80 \
    cjohansen/varnish-vmods
```
