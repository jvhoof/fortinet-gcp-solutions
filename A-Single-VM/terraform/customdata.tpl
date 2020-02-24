config system sdn-connector
	edit CGPSDN
		set type gcp
	end
end
config sys global
    set admintimeout 120
    set hostname "${fgt_vm_name}"
    set timezone 26
    set gui-theme mariner
end
config vpn ssl settings
    set port 7443
end
config router static
    edit 1
        set gateway ${fgt_external_gw}
        set device port1
    next
end
config system probe-response
    set http-probe-value OK
    set mode http-probe
end
config system interface
    edit port1
        set mode static
        set ip ${fgt_external_ipaddr}/${fgt_external_mask}
        set description external
        set allowaccess https ssh ping
    next
    edit port2
        set mode static
        set ip ${fgt_internal_ipaddr}/${fgt_internal_mask}
        set description internal
        set allowaccess https ssh ping
    next
end
