#cloud-config
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - dnsmasq
write_files:
  - owner: root:root
    path: /etc/dnsmasq.conf
    content: |
      port=53
      no-resolv
      log-queries=extra
      server=168.63.129.16
%{ for server in servers ~}
      server=/${server.domain}/${server.address}
%{ endfor ~}
      conf-dir=/etc/dnsmasq.d/,*.conf
bootcmd:
  # Ensure that WaLinuxAgent starts after cloud-final has finished.
  # Without this, Extensions and cloud-init will be run in parallel
  # causing issues (dpkg locks) with package installation.
  # TODO: Remove this when https://github.com/Azure/WALinuxAgent/issues/1938 is resolved
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  # Remove the multi-user.target from cloud-final.service to prevent cyclic dependency
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload
runcmd:
  - set -ex
  - dnsmasq --test
  - systemctl start dnsmasq
