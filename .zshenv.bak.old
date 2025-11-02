PATH="$(go env GOPATH)/bin:/opt/homebrew/opt/go@1.23/bin:google-cloud-sdk/bin/:/opt/homebrew/bin/:$PATH"

# pyenv setup
export pyenv_root="$home/.pyenv"
command -v pyenv >/dev/null || export path="$pyenv_root/bin:$path"
eval "$(pyenv init -)"

export PIP_REQUIRE_VIRTUALENV=true
syspip() {
    PIP_REQUIRE_VIRTUALENV="" python3 -m pip "$@" 
}

network_name=$(/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | awk '/ SSID:/ {print $2}')
office_network_name="WLANWork"
if [[ $network_name == $office_network_name ]]
then
    echo "Office Wifi"
    export CERT_PATH=~/certificate.pem  # office
else
    echo "Not office Wifi"
    export CERT_PATH=$(python3.11 -m certifi)
fi
export SSL_CERT_FILE=${CERT_PATH}
export CERT_DIR=/etc/ssl/certs/
export SSL_CERT_DIR=${CERT_DIR}
export CA_BUNDLE=${CERT_PATH}
export CURL_CA_BUNDLE=${CERT_PATH}
export REQUESTS_CA_BUNDLE=${CERT_PATH}
export AWS_CA_BUNDLE=$(python3.11 -m certifi)  # Always use Pythonn one, zscaler doesn't work
