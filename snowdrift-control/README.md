#### Summary

`snowdrift-control` is a temporary control server for our devops needs, until
we replace it with a robust, third party whoosy-whatsit with all the bellbos and
whongles we might ever want.

#### Functionality

* Listen on port `8001`
* On `POST /`,
    * Verify the request came from `https://travis-ci.org`
    * Run `sv restart snowdrift`
