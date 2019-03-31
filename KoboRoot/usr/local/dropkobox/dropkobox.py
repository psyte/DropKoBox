#!/usr/bin/python3
 
import dropbox
import os
import sys
import time
import configparser

dropbox_path='/'

print('DropKoBox python logs:')

if len(sys.argv) > 1 :
    if not os.path.isdir(sys.argv[1]) :
        print('Error: Library dir does not exist')
        quit()
    else:
        local_path = sys.argv[1]
    if not os.path.isfile(sys.argv[2]) :
        print('Error: Config file does not exist')
        quit()
    else:
        config_file = sys.argv[2]
else:
    print('Error: Not enough args (lib, config)')
    quit()

# Read token from config file
try:
    config = configparser.ConfigParser()
    config.read(config_file)
    token = config['DropKoBox']['Token']
    dbx=dropbox.Dropbox(token)
except:
    print("Error: couldn't read DropKoBox token from config file")
    quit()

# Connect to Dropbox
for retries in range(10):
    try:
        print(dbx.users_get_current_account())
    except:
        time.sleep(1)
        continue
    else:
        break   # Connected, let's continue
else:
    print("Error: Couldn't connect. Check token and connection")
    quit()


for entry in dbx.files_list_folder('').entries:
    # Make sure it's a file
    if isinstance(entry, dropbox.files.FileMetadata) :
        print(entry.name + ', ' + str(entry.size) + ', ' + entry.content_hash[0:15])

        # Check if file exists on destination; if yes, compare sizes
        if os.path.isfile(local_path + '/' + entry.name) :
            if os.path.getsize(local_path + '/'  + entry.name) == entry.size :
                print('Debug: Exists and same size, skipping')
                # TODO: Compare hashes? Slow and probably useless
                continue

        try:
            dbx.files_download_to_file(local_path + '/' + entry.name, entry.path_display)
        except dropbox.exceptions.ApiError as ae:
            print('Error: Restricted content = ' + str(ae.error.get_path().is_restricted_content()))
            continue
        print('Debug: Downloaded!')

    # TODO: folder handling
    if isinstance(entry, dropbox.files.FolderMetadata) :
        print('Debug: Folder ' + entry.name)

