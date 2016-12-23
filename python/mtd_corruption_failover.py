import subprocess
import time
# AVRORA-17230

passive = 'root@172.16.21.133'
raid_name = 'raid1'
lun_name = 'lunname'

ro_path = '/sys/devices/rvm/V:' + lun_name + '/parameters/read_only'
sync_path = '/sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync'


def check_ro():
    with open(ro_path, 'r') as myfile:
        ro_state = myfile.read().replace('\n', '')
    print ro_state
    if ro_state == 1:
        print "Reach read only state"
        quit()


def get_sync():
    with open(sync_path, 'r') as myfile:
        return myfile.read().replace('\n', '')


while True:
    process = subprocess.Popen(
        'rdcli r s -n ' + raid_name + ' | grep Passive',
        stdout=subprocess.PIPE, shell=True)
    state = process.communicate()[0]

    # If active
    if state == '':
        if get_sync() != 'Starting':
            subprocess.call(
                'rdcli raid reload -n ' + raid_name + ' -f', shell=True)
            print 'RELOAD RAID'

        while True:
            time.sleep(0.1)
            print 'SLEEP 0.1'
            if get_sync() == 'Starting':
                subprocess.call(
                    'ssh ' + passive + ' rdcli dc failover', shell=True)
                print "FAILOVER ON PASSIVE"
                break

        check_ro()
        time.sleep(31)
    else:
        subprocess.call('rdcli dc failback', shell=True)
        time.sleep(31)
