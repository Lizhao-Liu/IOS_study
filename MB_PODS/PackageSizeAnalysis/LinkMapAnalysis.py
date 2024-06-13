#!/usr/bin/python
#coding:utf-8

import encodings
import sys
import os

def read_base_link_map_file(base_link_map_file, base_link_map_result_file):
    print("[INFO] read_base_link_map_file path : " + base_link_map_file)
    try:
        link_map_file = open(base_link_map_file, "rb")
    except IOError:
        print("Read file " + base_link_map_file + " failed!")
        return
    else:
        # try:
        #     # content = link_map_file.read()
        # except IOError:
        #     print("Read file " + base_link_map_file + " failed!")
        #     return
        # else:
            # obj_file_tag_index = content.find("# Object files:")
            # sub_obj_file_symbol_str = content[obj_file_tag_index + 15:]
            # symbols_index = sub_obj_file_symbol_str.find("# Symbols:")
            # if obj_file_tag_index == -1 or symbols_index == -1 or content.find("# Path:") == -1:
            #     print("The Content of File " + base_link_map_file + " is Invalid.")
            #     pass
            link_map_file_tmp = open(base_link_map_file, "rb")
            reach_files = 0
            reach_sections = 0
            reach_symbols = 0
            size_map = {}
            while 1:
                line = link_map_file_tmp.readline()
                line = line.decode("utf8","ignore")
                if not line:
                    break
                if line.startswith("#"):
                    if line.startswith("# Object files:"):
                        reach_files = 1
                        pass
                    if line.startswith("# Sections"):
                        reach_sections = 1
                        pass
                    if line.startswith("# Symbols"):
                        reach_symbols = 1
                        pass
                    pass
                elif line.startswith("<<dead>>"):
                    pass
                else:
                    if reach_files == 1 and reach_sections == 0 and reach_symbols == 0:
                        index = line.find("]")
                        if index != -1:
                            symbol = {"file": line[index + 2:-1]}
                            key = int(line[1: index])
                            size_map[key] = symbol
                        pass
                    elif reach_files == 1 and reach_sections == 1 and reach_symbols == 0:
                        pass
                    elif reach_files == 1 and reach_sections == 1 and reach_symbols == 1:
                        symbols_array = line.split("\t")
                        if len(symbols_array) == 3:
                            file_key_and_name = symbols_array[2]
                            size = int(symbols_array[1], 16)
                            index = file_key_and_name.find("]")
                            if index != -1:
                                key = file_key_and_name[1:index]
                                key = int(key)
                                symbol = size_map[key]
                                if symbol:
                                    if "size" in symbol:
                                        symbol["size"] += size
                                        pass
                                    else:
                                        symbol["size"] = size
                                    pass
                                pass
                            pass
                        pass
                    else:
                        print("Invalid #3")
                        pass
            # size_map_sorted = sorted(size_map.items(), key=lambda y: y[1]["size"], reverse=True)
            # for item in size_map_sorted:
            #     print "%s\t%.2fM" % (item[1]["file"], item[1]["size"] / 1024.0 / 1024.0)
            #     pass
            total_size = 0
            a_file_map = {}
            for key in size_map:
                symbol = size_map[key]
                if "size" in symbol:
                    total_size += symbol["size"]
                    o_file_name = symbol["file"].split("/")[-1]
                    a_file_name = o_file_name.split("(")[0]
                    if a_file_name in a_file_map:
                        a_file_map[a_file_name] += symbol["size"]
                        pass
                    else:
                        a_file_map[a_file_name] = symbol["size"]
                        pass
                    pass
                else:
                    print("WARN : some error occurred for key ",)
                    print(key)

            a_file_sorted_list = sorted(a_file_map.items(), key=lambda x: x[1], reverse=True)
            print("%s" % "=".ljust(80, '='))
            print("%s" % (base_link_map_file+"各模块体积汇总").center(87))
            print("%s" % "=".ljust(80, '='))
            if os.path.exists(base_link_map_result_file):
                os.remove(base_link_map_result_file)
                pass
            print("Creating Result File : %s" % base_link_map_result_file)
            output_file = open(base_link_map_result_file, "w")
            for item in a_file_sorted_list:
                print("%s%d" % (str(item[0]).ljust(50), item[1]))
                output_file.write("%s \t\t\t%d\n" % (item[0].ljust(50), item[1]))
                pass
            print("%s%.2fM" % ("总体积:".ljust(53), total_size / 1024.0/1024.0))
            print("\n\n\n\n\n")
            # output_file.write("%s%.2fM" % ("总体积:".ljust(53), total_size / 1024.0/1024.0))
            link_map_file_tmp.close()
            output_file.close()
        # finally:
        #     link_map_file.close()
            return a_file_sorted_list


def parse_result_file(result_file_name):
    base_bundle_list = []
    result_file = open(result_file_name)
    while 1:
        line = result_file.readline()
        if not line:
            break
        bundle_and_size = line.split()
        if len(bundle_and_size) == 2 and line.find(":") == -1:
            bundle_and_size_map = {"name": bundle_and_size[0], "size": bundle_and_size[1]}
            base_bundle_list += [bundle_and_size_map]
            pass
    return base_bundle_list

def analysis(linkmap_filePath, app_code_type):
    output_file_path = os.path.dirname(linkmap_filePath)
    if output_file_path:
        base_output_file = output_file_path + "/BaseLinkMapResult.txt"
        pass
    else:
        base_output_file = "BaseLinkMapResult.txt"
        pass
    libList = []
    lib_size_list = read_base_link_map_file(linkmap_filePath, base_output_file)
    for item in lib_size_list:
        lib_dic = {}
        lib_dic['libName'] = str(item[0])
        lib_dic['libSize'] = item[1]/1024
        lib_dic['appCodeType'] = app_code_type
        libList.append(lib_dic)
        pass
    return libList


linkmap_filePath = "/Users/admin/Developer/MBNewOne/YMMDriver-LinkMap.txt"
app_code_type = "iOS" 


# 运行分析
result = analysis(linkmap_filePath, app_code_type)
print(result)
