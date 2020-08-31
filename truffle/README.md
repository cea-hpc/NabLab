# Nabla Interpreter

## Setup

### Nabla Interpreter

Download version 20.1.0 of GraalVM, which can be found [here](https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-20.1.0), and extract the archive in a folder (eg /home/username/graalvm/) which we will refer to as the GraalVM home from now on.
Go to your NabLab install folder and run the graalvm-setup.sh script, by providing the path to your GraalVM home as an argument.

### Monilog Tool

To enable the monilogging capability for the Nabla interpreter, download the archives available [here](https://github.com/gemoc/monilogger/releases/tag/v1.0.0) and [here](https://github.com/gemoc/miniexpr/releases/tag/v1.0.0), extract them in a folder of your choice, and run their corresponding graalvm-setup.sh scripts.
Once the script is run, the files can be safely deleted as they are not needed anymore.
Each archive also contain an update site (packaged as a zip file) which you can use to install the monilogger and miniexpr editors into your NabLab IDE, providing auto-completion and syntax highlighting for these languages.
To do so, in the NabLab IDE, go to **Help** > **Install New Software**, and click on the **Add...** button to indicate the update site you want to install features from.
Optionally give a name to the update site, click on the **Archive...** button and select the archive you want to use as an update site (monilog-syntax.zip or miniexpr-syntax.zip).
Click on **Add**, and select the proposed feature (monilog or miniexpr syntax) then click on **Next** twice.
Accept the licence and click on **Finish**.
When prompted, click on **Install anyway**.

## Running an Interpreted Nabla Execution 

In the NabLab IDE, got to **Run** > **Run Configurations...** and create a new **NabLa Interpreter Launch** configuration.
The first time you create a launch configuration, you need to indicate the directory corresponding to your GraalVM home, under the **GraalVM** tab of the launch configuration editor.
Subsequently created launch configurations will have this setting pre-filled automatically, but you can always change it.

You then need to provide the nabla source file that you want to execute, together with its accompanying nablagen file.
Finally, you can include monilogger definitions as a .mnlg file (information and examples on how to define moniloggers can be found [here](https://github.com/gemoc/monilog)).

Click on **Apply** to save your configuration, and **Run** to start the execution.

