 /$$$$$$$  /$$$$$$$$ /$$$$$$                                  /$$
| $$__  $$|__  $$__//$$__  $$                                | $$
| $$  \ $$   | $$  | $$  \__/        /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$  /$$$$$$/$$$$   /$$$$$$
| $$$$$$$    | $$  | $$             /$$__  $$| $$__  $$ /$$__  $$ /$$__  $$ |____  $$| $$_  $$_  $$ /$$__  $$
| $$__  $$   | $$  | $$            | $$$$$$$$| $$  \ $$| $$  | $$| $$  \ $$  /$$$$$$$| $$ \ $$ \ $$| $$$$$$$$
| $$  \ $$   | $$  | $$    $$      | $$_____/| $$  | $$| $$  | $$| $$  | $$ /$$__  $$| $$ | $$ | $$| $$_____/
| $$$$$$$/   | $$  |  $$$$$$/      |  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$$| $$ | $$ | $$|  $$$$$$$
|_______/    |__/   \______/        \_______/|__/  |__/ \_______/ \____  $$ \_______/|__/ |__/ |__/ \_______/
                                                                  /$$  \ $$
                                                                 |  $$$$$$/
                                                                  \______/


BTC endgame is a research project aiming to test defensive strategies of
the Bitcoin network under various attack scenarios, via a wargame.

v1 simulates a nation state sabotaging Bitcoin through a denial of service
attack on the network; preventing users' payments from going through by
stopping any transactions from being confirmed, trapping them in the mempool
forever.

The attack strategy works by using majority mining power to continually mine
empty blocks, which effectively "jams up" the network.

A detailed summary of the attack is here:
https://joekelly100.medium.com/how-to-kill-bitcoin-part-1-is-bitcoin-unstoppable-code-7a1b366f65ee
https://joekelly100.medium.com/how-to-kill-bitcoin-part-2-no-can-spend-66e59385a4a5

There is currently no defense for this attack in the Bitcoin protocol itself, as the
simulation demonstrates.

The idea of this wargame is to challenge others to develop a defense strategy
against the attack, in response to which further attack strategies can be
proposed and tested, then a further defense strategy, and so on and so forth.

Bitcoin users can choose to violate the heaviest chain rule and ignore specific
chains they beleive are nefarious. Bitcoin Core has an RPC endpoint called
`invalidateblock` for this purpose. An attacker can shape blocks (with their own transactions)
in order to make identifying nefarious chains harder for users, creating the risk of
chainsplits. For this reason, it is likely that mechanisms for coordinating
invalidateblock between nodes would be necessary. At time of writing, the
simulated attacker does not bother shaping blocks, mostly to save my time :)

The intent of this work is to research potential ways to make Bitcoin more
robust under attack, and to identify/discuss where there may be limitations or
trade-offs with various defensive strategies.

If you'd like to sponsor development of this project, you can do so here:

BTC: bc1q9nyrtnwfkh2yu5dejjzzpmlpe40g6mzyf6jave
XMR: 8BxwbtkaXmHLpG1F2E18QD8TLPU7yKp5gCM4towfR7xRMUFeJDaBHw8gck9BXYKoGJ9xpuvgBGtNc49BbtgzuRobJjmk7Ue


----------------------------------------------------------------------------------------------------


More tech details...

It is a simulation of mainnet Bitcoin, composed of various docker containers
orchestrated via docker-compose:

* full nodes
* blue team mining operation (ie. honest miners)
* red team mining operation (ie. the attacker)
* red team "noc" that orchestrates the attack strategy
* simulated users transacting on the network

Pulling submodule deps:

$ git submodule init && git submodule update


Running the simulation is a two step process:

$ ./seed-network.sh
$ docker-compose up -d


There's a block explorer included for observing the network, it's a web
server exposed on port 3002:

http://localhost:3002/blocks


If you want to inspect a node just exec into it and you can use bitcoin-cli
from there (the cookie auth is all setup for you):
$ docker-compose exec blue-node bash

Notes:
- At time of writing, it based on a fork of Bitcoin Core 0.21.0
