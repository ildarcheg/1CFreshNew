"""
Imprort user's profile pictures from MongoDB to files
"""

import pymongo
import bson
import os

#uri = 'mongodb://yellowlabs12:QGnnEft8yb@ds039921-a1.mongolab.com'

connection = pymongo.MongoClient('mongodb://support:!CmD3#20170429@ds039921-a1.mongolab.com:39921,ds039921-a0.mongolab.com:39921/dataset1cproduction?replicaSet=rs-ds039921')
db = connection.get_database('dataset1cproduction')
_image_chunks = db.get_collection('images.chunks')
_image_files = db.get_collection('images.files')
_file_id = None
# Browse throuth images.chunks in files_id order
for _image_chunk in _image_chunks.find().sort('files_id', 1):
    # Check if the current file ends/new file starts
    if _file_id != str(_image_chunk['files_id']):
        # Check if there is an open file and close it
        if _file_id != None:
            f.close()
        # Replace the _file_id with the new file id
        _file_id = str(_image_chunk['files_id'])
        # Find images.files item for the new file
        _email = None
        _image_file = _image_files.find_one({'_id': bson.objectid.ObjectId("{}".format(_file_id))})
        if _image_file == None:
            print("File not found! Id = " + _file_id)
        else:
            _image_file_name = _image_file['metadata']['email'] + '.' + _image_file['contentType'].split('/')[1]
            print(_image_file_name)
        # Open the new file
        f = open(_image_file_name, 'wb')
    # Add this chunk to the file
    f.write(bytearray(_image_chunk['data']))
f.close()    