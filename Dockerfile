FROM atmoz/sftp

COPY ./bindmount.sh /etc/sftp.d/bindmount.sh
COPY ./users.conf /etc/sftp/users.conf

COPY ./ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY ./ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key

EXPOSE 22