ARG  base_image_tag
ARG  carolina_ver
ARG  carolina_kernel_ver

FROM ${base_image_tag}


ENV CAROLINA_VER=${carolina_ver} \
    CAROLINA_KERNEL_VER=${carolina_kernel_ver} \
    CAROLINA_HOME=/opt/carolina


USER root:root

RUN mkdir -p /opt/carolina_files /home/wsuser/.local $CAROLINA_HOME \
   && chown -R wsbuild:wsbuild /opt/carolina_files \
   && chown -R wsbuild:wsbuild $CAROLINA_HOME \
   && chown -R wsbuild:wsbuild /home/wsuser/.local


USER wsbuild:wsbuild

COPY carolina_files /opt/carolina_files/

RUN id && ls -la /opt/carolina_files/* \
       && cd /opt/carolina_files \
       && tar -xzf carolina-$CAROLINA_VER.tar.gz \
              --strip-components 1 -C $CAROLINA_HOME \
       && tar -xzf carolina-ibmcloud-plugin-$CAROLINA_VER.tar.gz \
              --strip-components 1 -C $CAROLINA_HOME \
       && mkdir -p $CAROLINA_HOME/plugins/jupyter \
       && cp /opt/carolina_files/carolina.lic $CAROLINA_HOME/config \
       && cp /opt/carolina_files/carolina_kernel-$CAROLINA_KERNEL_VER.tar.gz \
             $CAROLINA_HOME/plugins/jupyter/carolina_kernel.tar.gz \
       && $CAROLINA_HOME/carolina -version \
       && source activate Python-3.6-WMLCE \
       && pip install --user --no-binary=carolina_kernel \
              $CAROLINA_HOME/plugins/jupyter/carolina_kernel.tar.gz \
       && cp -r /home/wsbuild/.local/lib/python3.6/site-packages/* \
                /opt/conda/envs/Python-3.6-WMLCE/lib/python3.6/site-packages/

USER root:root

RUN cp -r /home/wsbuild/.local/share/jupyter/kernels/carolina /opt/ibm/run/kernels \
       && sed -i -e "s/ipykernel/carolina_kernel/g" /opt/ibm/run/bin/python-kernel.sh

USER wsbuild:wsbuild


