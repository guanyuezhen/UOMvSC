# <p align=center>`Unified One-step Multi-view Spectral Clustering (IEEE TKDE 2022)`</p>

> **Authors:**
Chang Tang, Zhenglai Li (co-first author), Jun Wang, Xinwang Liu, Wei Zhang, En Zhu

This repository contains simple Matlab implementation of our paper [UOMvSC](https://ieeexplore.ieee.org/document/9769920).

### 1. Features

- **Joint exploring the information of graphs and embedding matrices.** Under the observation that the inner product of the embedding matrix is a low-rank approximation of the graph, we combine graphs and embedding matrices of different views to obtain a unified graph.

- **Simple but effective one-step clustering manner.** We directly capture the discrete clustering indicator matrix from the unified graph with an effective optimization algorithm.

### 2. Usage
+ Prepare the data:
    - Partial datasets used in our paper can be downloaded from [BaiduYun](https://pan.baidu.com/s/1FSSzkbA8KqCxaktfv6atww)(s3u3).

+ Prerequisites for Matlab:
    - Test on Matlab R2018a

+ Conduct clustering

### 3. Citation

Please cite our paper if you find the work useful:

    @article{Li_2022_UOMvSC,
         author={Tang, Chang and Li, Zhenglai and Wang, Jun and Liu, Xinwang and Zhang, Wei and Zhu, En},
        journal={IEEE Transactions on Knowledge and Data Engineering}, 
        title={Unified One-step Multi-view Spectral Clustering}, 
        year={2022},
        volume={},
        number={},
        pages={1-1},
        doi={10.1109/TKDE.2022.3172687}
        }

