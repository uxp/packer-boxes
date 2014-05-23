These templates assume a few things. 
* VMware Fusion 6.0.3
* [Packer 6.0](https://github.com/CorbanR/packer), build from my fork 


If you run the esxi templates, you will need to run as sudo. Not 100% sure why, but it won't make the necessarynetworking chnages otherwise.  

```
sudo packer build esxi-5.5-amd64.json
```



* File http/centos-6.5-preseed.cfg is 

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
