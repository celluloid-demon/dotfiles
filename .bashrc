
############################
#                          #
#          COMMON          #
#                          #
############################

# Source global definitions
if [ -f /etc/bashrc ]; then

    source /etc/bashrc

fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then

    PATH="$HOME/.local/bin:$HOME/bin:$PATH"

fi

export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then

    for rc in ~/.bashrc.d/*; do

        if [ -f "$rc" ]; then

            source "$rc"

        fi

    done

fi

unset rc

#####################################
#                                   #
#          DEVICE-SPECIFIC          #
#          CONFIGURATION            #
#                                   #
#####################################

if [ -f "${HOME}/.DEVICE" ]; then

    DEVICE="$(cat ${HOME}/.DEVICE)"

fi

device_rc_file="${HOME}/.bashrc.d.dev/${DEVICE}"

if [ -f "$device_rc_file" ]; then

    source "$device_rc_file"

else

    echo "Warning: Device-specific configuration file '$device_rc_file' not found. Skipping."

fi

unset DEVICE
unset device_rc_file
