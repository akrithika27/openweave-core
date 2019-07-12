#!/bin/bash

#
#    Copyright (c) 2017 Nest Labs, Inc.
#    All rights reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

# Example of Thead, WiFi, and WAN networks, which have:
# - one thread-only device ThreadNode
# - one thread-wifi border_gateway device BorderRouter
# - one access-point router onhub
# - one service node instance cloud
export PATH=$PATH:/usr/local/bin:$TRAVIS_BUILD_DIR/src/test-apps/happy/bin
echo "1111111111111111111111"
echo $USER
echo $PATH
echo "22222222222222222222222"
happy-network-add HomeThread thread
happy-network-address HomeThread 2001:db8:111:1::

happy-network-add HomeWiFi wifi
happy-network-address HomeWiFi 2001:db8:222:2::
happy-network-address HomeWiFi 10.0.1.0

happy-network-add Internet wan
happy-network-address Internet 192.168.100.0 

happy-node-add ThreadNode
happy-node-join --tap ThreadNode HomeThread

happy-node-add BorderRouter
happy-node-join --tap BorderRouter HomeThread
happy-node-join --tap BorderRouter HomeWiFi

happy-node-add --ap onhub
happy-node-join onhub HomeWiFi
happy-node-join onhub Internet

happy-node-add --service cloud
happy-node-join --tap cloud Internet

weave-fabric-add fab1
weave-node-configure
weave-network-gateway HomeThread BorderRouter

# happy-state -s thread_wifi_on_tap_ap_service.json
