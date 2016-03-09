#!/bin/bash

cd "$(dirname "$0")" 

# turn on verbose debugging output for parabuild logs.
set -x
# make errors fatal
set -e

# Check autobuild is around or fail
if [ -z "$AUTOBUILD" ] ; then 
    fail0
fi
if [ "$OSTYPE" = "cygwin" ] ; then
    export AUTOBUILD="$(cygpath -u $AUTOBUILD)"
fi

# Load autobuild provided shell functions and variables
set +x
eval "$("$AUTOBUILD" source_environment)"
set -x

NVAPI_ROOT_NAME="nvapi"
NVAPI_VERSION="361"

top="$(pwd)"
stage="$(pwd)/stage"

build=${AUTOBUILD_BUILD_ID:=0}
echo "${NVAPI_VERSION}.${build}" > "${stage}/VERSION.txt"

pushd "$NVAPI_ROOT_NAME$NVAPI_VERSION"

    mkdir -p "$stage/include/nvapi"
    mkdir -p "$stage/LICENSES"
    mkdir -p "$stage/lib/release"

    case "$AUTOBUILD_PLATFORM" in

        windows*)
            if [ "$AUTOBUILD_ADDRSIZE" = 32 ]
                then cp "lib/release/nvapi.lib" "$stage/lib/release/nvapi.lib"
                else cp "lib/release/nvapi64.lib" "$stage/lib/release/nvapi.lib"
            fi

            cp "include/nvapi/nvHLSLExtns.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvHLSLExtnsInternal.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvShaderExtnEnums.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_common.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_d3dext.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_salend.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_salstart.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_sli.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_stereo.h" "$stage/include/nvapi/"
            cp "include/nvapi/nvapi_lite_surround.h" "$stage/include/nvapi/"

            cp "LICENSES/NVAPI_SDK_License_Agreement.pdf" "$stage/LICENSES/NVAPI_SDK_License_Agreement.pdf"
        ;;
    esac
popd
pass
