import subprocess


def ping_ip(ip_address):
    """
    Ping IP address and return string:
    """
    reply = subprocess.run(
        [
            'docker',
            'exec',
            '-it',
            'clab-simple-evpn-vxlan-l2-client1',
            'bash',
            '-c',
            f"ping -c 3 -n {ip_address}"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding='utf-8'
    )

    print(f"Pinging client2 ({ip_address}) from client1 over VNI 110...", end='')

    if reply.returncode == 0:
        return ("SUCCESS")
    else:
        return ("FAILURE")

print(ping_ip('10.10.1.2'))
    