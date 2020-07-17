# stones
## black
### set
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~1~~1 carpet 0 summon armor_stand b ~1~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~1~~-1 carpet 0 summon armor_stand b ~1~~-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~-1~~1 carpet 0 summon armor_stand b ~-1~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~-1~~-1 carpet 0 summon armor_stand b ~-1~~-1
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set] add sqrt
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~1~~ carpet 0 summon armor_stand b ~1~~
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~~~1 carpet 0 summon armor_stand b ~~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~~~-1 carpet 0 summon armor_stand b ~~~-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~-1~~ carpet 0 summon armor_stand b ~-1~~
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set,tag=!sqrt] add nsqrt
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,c=1] ~~~ execute @e[r=1.5,type=endermite] ~~~ fill ~~~~~~ carpet 15 replace air -1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=endermite] ~~~ detect ~~~ air -1 tellraw @p {"rawtext":[{"text":"<othello_black> んん〜？？"}]}
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set] ~~~ tp @s ~~~ facing @e[r=1.5,type=endermite]
execute @e[name=othello] ~~~ kill @e[dx=9,dy=2,dz=9,type=endermite]
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set] ~~~ tp @s ~~~~180
execute @e[name=othello,tag=!fin] ~~~ effect @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set] invisibility 10 1 true
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!set] add set
### main
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=sqrt,tag=!f] ~~~ tp @s ^^^1.41421356
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=nsqrt,tag=!f] ~~~ tp @s ^^^1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b] ~~~ detect ~~~ air -1 tp @s ~ -64 ~
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=!f] ~~~ detect ~~~ carpet 15 tag @s add f
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=f] ~~~ detect ~~~ carpet 0 setblock ~~~ carpet 15 destroy
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=sqrt,tag=f] ~~~ tp @s ^^^-1.41421356
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=nsqrt,tag=f] ~~~ tp @s ^^^-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=b,tag=f] ~~~ detect ~~~ carpet 15 tp @s ~ -64 ~
## white
### set
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~1~~1 carpet 15 summon armor_stand w ~1~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~1~~-1 carpet 15 summon armor_stand w ~1~~-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~-1~~1 carpet 15 summon armor_stand w ~-1~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~-1~~-1 carpet 15 summon armor_stand w ~-1~~-1
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set] add sqrt
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~1~~ carpet 15 summon armor_stand w ~1~~
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~~~1 carpet 15 summon armor_stand w ~~~1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~~~-1 carpet 15 summon armor_stand w ~~~-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~-1~~ carpet 15 summon armor_stand w ~-1~~
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set,tag=!sqrt] add nsqrt
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,c=1] ~~~ execute @e[r=1.5,type=silverfish] ~~~ fill ~~~~~~ carpet 0 replace air -1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=silverfish] ~~~ detect ~~~ air -1 tellraw @p {"rawtext":[{"text":"<othello_white> んん〜？？"}]}
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set] ~~~ tp @s ~~~ facing @e[r=1.5,type=silverfish]
execute @e[name=othello] ~~~ kill @e[dx=9,dy=2,dz=9,type=silverfish]
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set] ~~~ tp @s ~~~~180
execute @e[name=othello,tag=!fin] ~~~ effect @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set] invisibility 10 1 true
execute @e[name=othello,tag=!fin] ~~~ tag @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!set] add set
### main
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=sqrt,tag=!f] ~~~ tp @s ^^^1.41421356
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=nsqrt,tag=!f] ~~~ tp @s ^^^1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w] ~~~ detect ~~~ air -1 tp @s ~ -64 ~
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=!f] ~~~ detect ~~~ carpet 0 tag @s add f
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=f] ~~~ detect ~~~ carpet 15 setblock ~~~ carpet 0 destroy
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=sqrt,tag=f] ~~~ tp @s ^^^-1.41421356
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=nsqrt,tag=f] ~~~ tp @s ^^^-1
execute @e[name=othello,tag=!fin] ~~~ execute @e[dx=9,dy=2,dz=9,type=armor_stand,name=w,tag=f] ~~~ detect ~~~ carpet 0 tp @s ~ -64 ~
# fin
##set
execute @e[name=othello,tag=fin,tag=!set] ~~~ title @a[x=~4.5,y=~1,z=~4.5,r=16] actionbar 集計を開始します…
execute @e[name=othello,tag=fin,tag=!set] ~~~ summon armor_stand fin ~1~2~1
#//下げて
#//カウント保存用アマすた召喚*2
#//走査→回す
#//走査kill
#//回して書き出す
#//どちらかが先に回りきった時点でname=othelloにtagかなんかで保存
#//title→kill
