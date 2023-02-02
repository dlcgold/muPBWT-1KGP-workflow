rule makeMupbwt:
    input:
        panel = os.path.join(input_folder, "{chr}", "panel_{chr}.bcf"),
    output:
        ser = os.path.join(output_folder, "mupbwt", "{chr}", "{chr}.ser"),
    log:
        log = os.path.join(output_folder, "mupbwt", "{chr}", "make.log"),
        time = os.path.join(output_folder, "mupbwt", "{chr}", "make.time"),
    conda: "../envs/mupbwt.yml"
    threads: 22
    shell:
        """
        /usr/bin/time --verbose -o {log.time} mupbwt -i {input.panel} -s {output.ser} &> {log.log}
        """
        
rule runMupbwt:
    input:
        mupbwt = os.path.join(output_folder, "mupbwt", "{chr}", "{chr}.ser"),
        query = os.path.join(input_folder, "{chr}", "query_{chr}.bcf"),
    output:
        res = os.path.join(output_folder, "mupbwt", "{chr}", "output.txt"),
        stat = os.path.join(output_folder, "mupbwt", "{chr}", "stat.txt"),
    log:
        log = os.path.join(output_folder, "mupbwt", "{chr}", "exe.log"),
        time = os.path.join(output_folder, "mupbwt", "{chr}", "exe.time"),
    conda: "../envs/mupbwt.yml"
    threads: 22
    shell:
        """
        OMP_NUM_THREADS=1 /usr/bin/time --verbose -o {log.time}  mupbwt -l {input.mupbwt} -q {input.query} -o {output.res} &> {log.log}
        mupbwt -l {input.mupbwt} -d > {output.stat}
        """
