#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide for a comprehensive documentation
# at https://www.varnish-cache.org/docs/.

# Marker to tell the VCL compiler that this VCL has been written with the
# 4.0 or 4.1 syntax.
vcl 4.1;

# Default backend definition. Set this to point to your content server.
backend drawio {
    .host = "drawio";
    .port = "8080";
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.

	  set req.backend_hint = drawio;


		# Remove cookie for image files. cache them..
		if ((req.url ~ "\.(js|css|woff|woff2|gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf|svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)(\?.*)?$")) {
			unset req.http.cookie;
			return(hash);
		}
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

		if ((bereq.url ~ "\.(js|css|woff|woff2|gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf|svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)(\?.*)?$")) {
			unset beresp.http.set-cookie;
			set beresp.http.cache-control = "public, max-age=2592000";
			set beresp.ttl = 30d;
			return (deliver);
		}

}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
