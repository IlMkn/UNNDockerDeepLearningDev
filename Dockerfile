FROM  continuumio/miniconda3

ENV APP_HOME /meshcnn
WORKDIR $APP_HOME
COPY . $APP_HOME

#---------------- Prepare the envirennment
RUN conda update --name base conda -y &&\
    conda env create --file environment.yaml

SHELL ["conda", "run", "--name", "meshcnn", "/bin/bash", "-c"]

ADD shrec_16.tar.gz /datasets

RUN ["conda", "run", "--name", "meshcnn", "python", "train.py", "--dataroot", "/datasets/shrec_16", "--name", "shrec16", "--ncf",  "64", "128", "256", "256", "--pool_res", "600", "450", "300", "180", "--norm", "group", "--resblocks", "1", "--flip_edges", "0.2", "--slide_verts", "0.2", "--num_aug", "20", "--niter_decay", "100", "--gpu_ids", "-1"]

ENTRYPOINT ["conda", "run", "--name", "meshcnn", "python", "test.py", "--dataroot", "/datasets/shrec_16", "--name", "shrec16", "--ncf",  "64", "128", "256", "256", "--pool_res", "600", "450", "300", "180", "--norm", "group", "--resblocks", "1", "--export_folder", "meshes", "--gpu_ids", "-1"]
