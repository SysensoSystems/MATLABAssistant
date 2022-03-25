%% *|MATLAB Assistant|*
%
% MATLAB Assistant is a voice assistant tool that helps to perform predefined activities within MATLAB/Simulink.
%
%
% Developed by: <http://www.sysenso.com Sysenso Systems>
%
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%
% *|Prerequisite|*
%
% * MATLAB & SIMULINK version 2015b-2020a
%
% * Python version 3.9
%
% * *Note:* Please note that the Python is installed and added to the system
% path. Also the following modules are installed within Python.
%
% # <https://pypi.org/project/SpeechRecognition/ SpeechRecognition>
% # <https://pypi.org/project/playsound/ playsound>
% # <https://pypi.org/project/gtts/ gTTS>
% # <https://pypi.org/project/pyaudio/ PyAudio>
%
% * *Important:* Please note that this utility is developed to share an
% idea of using voice recognization within MATLAB. There are some more
% error handling and improvements needed in this utility to use it as a
% real-world application. If there are any usage issues, it is expected
% that the user should be capable of debugging it and improving it.
%
%
% *|Usage Information|*
%%
%
% Please follow the following steps for the usage of 
% *MATLAB Assistant* in MATLAB.
%
% * Please install the MATLABAssistant.mlappinstall which is under the utils folder.
%
% <<\images\\installAssistant.png>>
%
% * Once installed, the app *MATLAB Assistant* becomes visible under APPS
% Tab.
%
% <<\images\\appsTab.png>>
%
% * Launch MATLAB Assistant App.
%
% * The following predefined commands can be given as voice input to use the MATLAB
% Assistant.
%
% # 'hey','hi','hello' for greetings.
% # 'what is your name','what's your name','tell me your name' for getting
% app name.
% # 'my name is (username)' to tell user name.
% # 'how are you','how are you doing' for greetings.
% # 'what's the time','tell me the time','what time is it' to know the
% time.
% # 'search web for (search word)' to search anything in web.
% # 'search youtube for (search word)' to search anything in youtube.
% # 'help (inbuilt function)' to get the documentation for the inbuilt function in command window.
% # 'search documentation for (search word)' to search anything in MATLAB documentation.
% # 'clear base workspace' to clear the base workspace. 
% # 'clear command window screen' to clear the command window screen.
% # 'open script as (script name)' to open a new script or an existing script with name as (script name).
% # 'run matlab script (script name)' to run the given script as input.
% # 'run active matlab script' to run the active MATLAB script in the editor window.
% # 'open simulink' to open SIMULINK starting window.
% # 'open simulink library browser' to open Simulink Library Browser.
% # 'open new system' to open a Simulink system.
% # 'open system (system name)' to open the Simulink system given as input.
% # 'simulate system (system name)' to simulate the Simulink system given as input.
% # 'simulate active system' to simulate the active Simulink system.
% # 'about matlab assistant' to open the MATLAB Assistant document.
% # 'exit matlab' to close the MATLAB window.
% # 'exit', 'quit', 'goodbye' to exit the MATLAB Assistant.
% 
% *|Developer notes|*
%
% * *Adding new Commands*
%
% The following example shows the logic of how to clear command window screen using MATLAB Assistant.
%%
% 
%   existFlag = thereExists({'clear command window screen'}, voiceData);
%   if existFlag
%       eval(char('clc'));
%       disp('MATLAB Assistant: command window screen is cleared');
%       py.record.speak(py.str('command window screen is cleared'));
%       return;
%   end
% 
% The logic first checks whether voice input contains 'clear command
% window screen' string.
%
% If the voiceData contains the string, then clear screen command i.e.
% '*clc*' is executed using '*eval*' command.
% 
% Like the above example, the developer can easily add more automation in the MATLAB Assistant.
% 
% * *Python Functions*
%
% Python logic is coded in utils/assistantRecord.py. The user may have to
% update this functions to have better voice recognization. 
% Please refer "Troubleshooting" section from the
% https://pypi.org/project/SpeechRecognition/2.1.3/ page.
% 