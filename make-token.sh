#!/usr/bin/env bash
#
# GitHub repo:
#    https://github.com/snobu/Azure-IoT-Hub
#
# Construct authorization header for Azure IoT Hub
#    https://azure.microsoft.com/en-us/documentation/articles/iot-hub-devguide/#security
#
# The security token has the following format:
#    SharedAccessSignature sig={signature-string}&se={expiry}&skn={policyName}&sr={URL-encoded-resourceURI}
#
# Author:
#    Adrian Calinescu
#    @evilSnobu on Twitter
#    https://github.com/snobu
#
# Many things borrowed from:
#    http://stackoverflow.com/questions/20103258/accessing-azure-blob-storage-using-bash-curl
#
# Prereq:
#    OpenSSL
#    npm install underscore -g (for the tidy JSON colorized output) - OPTIONAL
#    Python 2.6 (Might work with 2.5 too)
#    curl (a build from this century should do)

urlencodesafe() {
    # Use urllib to safely urlencode stuff
    python -c "import urllib, sys; print urllib.quote_plus(sys.argv[1])" $1
}

iothub_name="heresthething"
apiversion="2015-08-15-preview"
req_url="${iothub_name}.azure-devices.net/devices?top=100&api-version=${apiversion}"

sas_key="eU2XXXXXXXXXXXXXXXXXXXXXXXXXXXXX="
sas_name="iothubowner"

authorization="SharedAccessSignature"

# 259200 seconds = 72h (Signature is good for the next 72h)
expiry=$(echo $(date +%s)+259200 | bc)
req_url_encoded=$(urlencodesafe $req_url)
string_to_sign="$req_url_encoded\\n$expiry"

# Create the HMAC signature for the Authorization header
#
# In pseudocode:
#      BASE64_ENCODE(HMAC_SHA256($string_to_sign))
#
# With OpenSSL it's a little more work (StackOverflow thread at the top for details)
decoded_hex_key=$(printf %b "$sas_key" | base64 -d -w0 | xxd -p -c256)
signature=$(printf %b "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary | base64 -w0)

# URLencode computed HMAC signature
sig_urlencoded=$(urlencodesafe $signature)

# Print Authorization header
authorization_header="Authorization: $authorization sr=$req_url_encoded&sig=$sig_urlencoded&se=$expiry&skn=$sas_name"

echo -e "\n$authorization_header\n"

# We're ready to make the GET request against azure-devices.net REST API
curl -s -H "$authorization_header" "https://$req_url" | underscore print --color

echo -e "\n"
