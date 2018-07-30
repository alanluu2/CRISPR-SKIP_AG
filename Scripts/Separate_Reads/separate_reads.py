import csv
from Bio import Seq
import sys

with open('/home/groups/song/songlab2/alanluu2/CRISPR-SKIP_AG/Data/Primers/primers.csv', 'r') as primer_file:
    primer_reader = csv.reader(primer_file)
    primer_dict = {}
    for row in primer_reader:
        k = row[1]
        v = row[0].replace(' ','_')
        k_rc = Seq.reverse_complement(k)
        v_rc = v+"_RC"
        v = v+"_N"
        primer_dict[k] = v
        primer_dict[k_rc] = v_rc

def standard_slash(folder):
    if folder[-1] == '/':
        return folder
    else:
        return folder+'/'

EXON_LIST = ['CTNNA1_Ex7', 'HSF1_Ex11', 'JUP_Ex10', 'AHCY_Ex9', 'RAD51_Ex7']

def make_readers(exp, in_path):
    in_path = standard_slash(in_path)
    r1 = open(in_path+exp+"_R1.fastq", 'r')
    r2 = open(in_path+exp+"_R2.fastq", 'r')
    return [r1, r2]

def make_writer_dict(exp, out_path):

    out_path = standard_slash(out_path)

    writer_dict = {}

    w1_g = open(out_path+exp+"_g_R1.fastq", 'w')
    w2_g = open(out_path+exp+"_g_R2.fastq", 'w')
    w_g_pair = [w1_g, w2_g, 0]
    writer_dict['gDNA'] = w_g_pair

    w1_n = open(out_path+exp+"_n_R1.fastq", 'w')
    w2_n = open(out_path+exp+"_n_R2.fastq", 'w')
    writer_dict['None'] = [w1_n, w2_n, 0]

    for k, v in primer_dict.items():
        if 'cDNA' not in v:
            writer_dict[v] = w_g_pair

    for exon in EXON_LIST:
        tmp_pair = [open(out_path+exp+'_{}_R1.fastq'.format(exon), 'w'),
                    open(out_path+exp+'_{}_R2.fastq'.format(exon), 'w'),
                    0]
        writer_dict[exon] = tmp_pair
        for k, v in primer_dict.items():
            if 'cDNA' in v and exon in v:
                writer_dict[v] = tmp_pair
    writer_dict['RNA'] = 0

    return writer_dict

def separate_reads(exp, in_path, out_path):
    r_pair = make_readers(exp, in_path)
    read_num = 0
    print("Initializing {}.".format(exp))
    for line in r_pair[0]:
        read_num += 1
    r_pair[0].seek(0)
    total = 0
    writer_dict = make_writer_dict(exp, out_path)
    entry1 = []
    entry2 = []
    cur_writer = None
    print("Separating {}.".format(exp))
    for n in range(read_num):
        entry1.append(r_pair[0].readline())
        entry2.append(r_pair[1].readline())
        if len(entry1) != 4:
            continue
        total += 1
        seq1 = entry1[1]
        seq2 = entry2[1]
        for k, v in primer_dict.items():
            if k in seq1 or k in seq2:
                cur_writer = writer_dict[primer_dict[k]]
                break
        if cur_writer == None:
            cur_writer = writer_dict['None']
        cur_writer[2] += 1
        for i in range(4):
            cur_writer[0].write(entry1[i])
            cur_writer[1].write(entry2[i])
        cur_writer = None
        entry1 = []
        entry2 = []
    writer_dict["Total"] = total
    RNA_total = 0
    for exon in EXON_LIST:
        RNA_total += writer_dict[exon][2]
    writer_dict['RNA'] = [None, None, RNA_total]
    return writer_dict

EXP_LIST = ['GFP', 'ABE', 'ABE_UGI', 'L25', 'aCas9']

def percentify(num, total):
    return 100*float(num)/total

def separate_file(full_exp, file_out, fastq_in_path, fastq_out_path):
    meta = open(file_out, 'a')
    print("Starting separation of {}.".format(full_exp))
    writer_dict = separate_reads(full_exp, fastq_in_path, fastq_out_path)
    meta.write('{}\t{}'.format(full_exp,writer_dict['Total']))
    for key in ['gDNA', 'None', 'RNA'] + EXON_LIST:
        meta.write('\t{}\t{:2.2f}'.format(
            writer_dict[key][2], percentify(writer_dict[key][2], writer_dict["Total"])))
    meta.write('\n')

if __name__ == "__main__":
    separate_file(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
