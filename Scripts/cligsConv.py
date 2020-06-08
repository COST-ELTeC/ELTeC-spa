#import git
import glob
import subprocess
import os
import sys

def gitPull(repoDir):
    cmd = ['git', 'pull']
    p = subprocess.Popen(cmd, cwd=repoDir)
    p.wait()

repoRoot='/home/lou/Public/ELTeC-spa'
schemaDir='/home/lou/Public/Schemas/'
inDir=repoRoot+'/cligs/novela-espanola/tei/'
outDir=repoRoot+'/Out/'
cligsConv=repoRoot+'/Scripts/cligstoeltec.xsl'

print("Converting from "+inDir+' to '+outDir)
os.chdir(inDir)
FILES=sorted(glob.glob('*.xml'))
for FILE in FILES:
    command="saxon "+FILE+" "+cligsConv+" > "+outDir+FILE
    print(command)
    subprocess.check_output(command,shell=True)
    command="jing "+schemaDir+"eltec-1.rng "+outDir+FILE
    print(command)
    subprocess.check_output(command,shell=True)
    
