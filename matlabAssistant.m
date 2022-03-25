function matlabAssistant
% MATLABAssistant is a utility, which helps to perform predefined
% processes based on user's commands through speech.
%
% This function is packaged within MATLABAssistant application. It can also
% be used independently from the MATLAB command window.
% >>matlabAssistant
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%

% Check if python is installed.
errorMessage = ['1. SpeechRecognition - https://pypi.org/project/SpeechRecognition/' char(10), ...
    '2. playsound - https://pypi.org/project/playsound/' char(10), ...
    '3. gTTS - https://pypi.org/project/gtts/' char(10), ...
    '4. PyAudio - https://pypi.org/project/pyaudio/'];
try
    pyVersionString = pyversion;
    [~,moduleString] = system('pip list');
catch
    msgbox(['To use MATLAB Assistant, Python has to be installed in the machine. Also, the following packages has to be available in the Python.' char(10)  errorMessage],'Error');
    return;
end
if isempty(strfind(moduleString,'SpeechRecognition')) || ...
        isempty(strfind(moduleString,'playsound')) || ...
        isempty(strfind(moduleString,'gTTS')) || ...
        isempty(strfind(moduleString,'PyAudio'))
    msgbox(['Please install the following Python packages.' char(10)  errorMessage],'Error');
    return;
end

% Initializing userName as global variable for frequent usage.
global userName;
[~,userStr] = system('echo %USERNAME%');
userName = userStr(1:end-1);
% Adding directory to python path.
rootPath = mfilename('fullpath');
[filePath,~,~] = fileparts(rootPath);
if count(py.sys.path,filePath) == 0
    insert(py.sys.path,int32(0),filePath);
end
try
    audioFile = [strrep(tempdir,'\','\\') 'matlabassistant.mp3'];
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('matlab assistant is active'));
catch
    msgbox(['Please install the following packages in python ' char(10)  errorMessage],'Info');
    return
end

while true
    % Get the voice input.
    try
        voiceData = py.assistantRecord.recordAudioInput(py.str(audioFile));
    catch eObj
        msgbox(['Please install the following packages in python ' char(10)  errorMessage],'Info');
        return;
    end
    existFlag = thereExists({'exit', 'quit', 'goodbye'}, voiceData);
    if existFlag
        % Exit.
        py.assistantRecord.speakOutput(py.str(audioFile), py.str('going offline'));
        disp('MATLAB Assistant: going offline');
        return;
    end
    if ~isempty(char(voiceData))
        if ~isempty(userName)
            disp([userName ': ' char(voiceData)]);
        else
            disp(['user: ' char(voiceData)]);
        end
        % Respond.
        respondVoiceInput(audioFile,voiceData);
    end
end

end
%--------------------------------------------------------------------------
function existFlag = thereExists(terms, voiceData)
% This function helps to check whether any of the listed word is present.

existFlag = false;
for term = terms
    matchWord = regexp(char(voiceData),['[\W]*' term{1} '[\W]*'],'match');
    if ~isempty(matchWord)
        existFlag = true;
        return;
    end
end

end
%--------------------------------------------------------------------------
function respondVoiceInput(audioFile,voiceData)
% This function helps to respond according to user's input.

global userName
% 1: Greeting.
existFlag = thereExists({'hey','hi','hello'}, voiceData);
if existFlag
    greetings = {['hey, how can I help you ' userName] ['hey, what''s up? ' userName] ['I''m listening ' userName] ['how can I help you? ' userName] ['hello ' userName]};
    greet = greetings(int64(py.random.randint(1,length(greetings))));
    disp(['MATLAB Assistant: ' greet{1}]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(greet{1}));
    return;
end

% 2: UserName.
existFlag = thereExists({'what is your name','what''s your name','tell me your name'}, voiceData);
if existFlag
    if ~isempty(userName)
        disp('MATLAB Assistant: my name is Matlab Assistant');
        py.assistantRecord.speakOutput(py.str(audioFile), py.str('my name is Matlab Assistant'));
    else
        disp('MATLAB Assistant: my name is Matlab Assistant. what''s your name?');
        py.assistantRecord.speakOutput(py.str(audioFile), py.str('my name is Matlab Assistant. what''s your name?'));
    end
    return;
end
existFlag = thereExists({'my name is'}, voiceData);
if existFlag
    name = split(voiceData,' is ');
    userName = char(name{end});
    disp(['MATLAB Assistant: okay, i will remember that ' userName]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['okay, i will remember that ' userName]));
    return;
end
existFlag = thereExists({'how are you','how are you doing'}, voiceData);
if existFlag
    disp(['MATLAB Assistant: I''m very well, thanks for asking ' userName]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['I''m very well, thanks for asking ' userName]));
    return;
end

% 3: Time.
existFlag = thereExists({'what is the time', 'tell me the time','what time is it'}, voiceData);
if existFlag
    time = regexp(datestr(now,'HH:MM:SS.FFF'),':','split');
    if strcmp(time{1},'00')
        hours = '12';
    else
        hours = time{1};
    end
    minutes = time{2};
    time = ['time is ' hours minutes];
    disp(['MATLAB Assistant: ' time]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(time));
    return;
end

% 4: Search google.
existFlag = thereExists({'search web for'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' for ','split');
    url = ['https://google.com/search?q=' char(searchTerm{end})];
    web(url);
    disp(['MATLAB Assistant: Here is what I found for ' char(searchTerm{end}) ' on google']);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Here is what I found for ' char(searchTerm{end}) ' on google']));
    return;
end

% 5: Search youtube.
existFlag = thereExists({'search youtube for'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' for ','split');
    url = ['https://www.youtube.com/results?search_query=' char(searchTerm{end})];
    web(url);
    disp(['MATLAB Assistant: Here is what I found for ' char(searchTerm{end}) ' on youtube']);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Here is what I found for ' char(searchTerm{end}) ' on youtube']));
    return;
end

% 6: Help MATLAB.
existFlag = thereExists({'help'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),'help ','split');
    disp(['MATLAB Assistant: Here is what I found for ' char(searchTerm{end}) ' on MATLAB']);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Here is what I found for ' char(searchTerm{end}) ' on MATLAB']));
    eval(['help ' char(searchTerm{end})]);
    return;
end

% 7: Document MATLAB.
existFlag = thereExists({'search documentation for'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' for ','split');
    disp(['MATLAB Assistant: Here is what I found for ' char(searchTerm{end}) ' on MATLAB documentation']);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Here is what I found for ' char(searchTerm{end}) ' on MATLAB documentation']));
    eval(['doc ' char(searchTerm{end})]);
    return;
end

% 8: Clear workspace data.
existFlag = thereExists({'clear base workspace'}, voiceData);
if existFlag
    eval(char('clear'));
    disp('MATLAB Assistant: Base workspace is cleared');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('Base workspace is cleared'));
    return;
end

% 9: Clear screen.
existFlag = thereExists({'clear command window screen'}, voiceData);
if existFlag
    eval(char('clc'));
    disp('MATLAB Assistant: command window screen is cleared');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('command window screen is cleared'));
    return;
end

% 10: Exit MATLAB.
existFlag = thereExists({'exit matlab'}, voiceData);
if existFlag
    disp('MATLAB Assistant: Closing MATLAB window.....');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('Closing MATLAB window.....'));
    eval(char('quit(''force'')'));
    return;
end

% 11: Open MATLAB Script.
existFlag = thereExists({'open script as'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' as ','split');
    filePath = which(char(searchTerm{end}));
    if ~isempty(filePath)
        [dir,fileName,ext] = fileparts(filePath);
        if strcmp(ext,'.m')
            disp(['MATLAB Assistant: Opening script ' char(searchTerm{end})]);
            py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Opening script ' char(searchTerm{end})]));
        else
            disp(['MATLAB Assistant: Opening new script as ' char(searchTerm{end})]);
            py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Opening new script as ' char(searchTerm{end})]));
        end
    else
        disp(['MATLAB Assistant: Opening new script as ' char(searchTerm{end})]);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Opening new script as ' char(searchTerm{end})]));
    end
    eval(['edit ' char(searchTerm{end})]);
    return;
end

% 12: Run MATLAB Script.
existFlag = thereExists({'run matlab script'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' script ','split');
    disp(['MATLAB Assistant: running script ' char(searchTerm{end})]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['running script ' char(searchTerm{end})]));
    try
        eval(char(searchTerm{end}));
    catch
        disp(['MATLAB Assistant: please ensure that the script ' char(searchTerm{end}) ' is added to the path.']);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['please ensure that the script ' char(searchTerm{end}) ' is added to the path.' ]));
    end
    return;
end

% 13: Run active MATLAB Script.
existFlag = thereExists({'run active matlab script'}, voiceData);
if existFlag
    % Check whether there is any active m file
    activeFileName = matlab.desktop.editor.getActive;
    if ~isempty(activeFileName)
        filePath = activeFileName.Filename;
        [~,mfileName,~] = fileparts(filePath);
        disp(['MATLAB Assistant: running script ' mfileName]);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['running script ' mfileName]));
        try
            eval(mfileName);
        catch
            disp(['MATLAB Assistant: please ensure that the script ' mfileName ' is added to the path.' ]);
            py.assistantRecord.speakOutput(py.str(audioFile), py.str(['please ensure that the script ' mfileName ' is added to the path.' ]));
        end
    else
        disp('MATLAB Assistant: There is no active matlab script.');
        py.assistantRecord.speakOutput(py.str(audioFile), py.str('There is no active matlab script.'));
    end
    return;
end

% 14: Open new Simulink system.
existFlag = thereExists({'open new system'}, voiceData);
if existFlag
    untitledSystemHandle = new_system;
    systemName = get_param(untitledSystemHandle,'Name');
    disp(['MATLAB Assistant: Opening new system as' systemName]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['Opening new system as' systemName]));
    open_system(systemName);
    return;
end

% 15: Open Simulink system.
existFlag = thereExists({'open system'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' system ','split');
    try
        disp(['MATLAB Assistant: opening system ' char(searchTerm{end})]);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['opening system ' char(searchTerm{end})]));
        open_system(char(searchTerm{end}));
    catch
        disp(['MATLAB Assistant: please ensure that the syatem ' char(searchTerm{end}) ' is added to the path.' ]);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['please ensure that the syatem ' char(searchTerm{end}) ' is added to the path.' ]));
    end
    return;
end

% 16: Run Simulink system.
existFlag = thereExists({'simulate system'}, voiceData);
if existFlag
    searchTerm = regexp(char(voiceData),' system ','split');
    disp(['MATLAB Assistant: simulating system ' char(searchTerm{end}) ' ....']);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['simulating system ' char(searchTerm{end}) ' ....']));
    try
        eval(['sim(''' char(searchTerm{end}) ''')']);
    catch
        disp(['MATLAB Assistant: please ensure that the system ' char(searchTerm{end}) ' is opened.' ]);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['please ensure that the system ' char(searchTerm{end}) ' is opened.' ]));
    end
    return;
end

% 17: Run active Simulink system.
existFlag = thereExists({'simulate active system'}, voiceData);
if existFlag
    try
        disp(['MATLAB Assistant: simulating system ' gcs ' ....']);
        py.assistantRecord.speakOutput(py.str(audioFile), py.str(['simulating system ' gcs ' ....']));
        eval(['sim(' gcs ')']);
    catch
        disp('MATLAB Assistant: please ensure that there is active system.');
        py.assistantRecord.speakOutput(py.str(audioFile), py.str('please ensure that there is active system.'));
    end
    return;
end

% 18: Open Simulink.
existFlag = thereExists({'open simulink'}, voiceData);
if existFlag
    disp('MATLAB Assistant: opening simulink starting window....');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('opening simulink starting window....'));
    eval('simulink');
    return;
end

% 19: Open Simulink library browser.
existFlag = thereExists({'open simulink library browser'}, voiceData);
if existFlag
    disp('MATLAB Assistant: opening simulink library browser....');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('opening simulink library browser....'));
    eval('slLibraryBrowser');
    return;
end

% 20: Open MATLAB assistant document.
existFlag = thereExists({'about matlab assistant'}, voiceData);
if existFlag
    disp('MATLAB Assistant: Opening matlab assistant document....');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('Opening matlab assistant document....'));
    eval('winopen(''matlabAssistant_doc.pdf'')');
    return;
end

if ~isempty(userName)
    disp(['MATLAB Assistant: I cannot understand ' userName]);
    py.assistantRecord.speakOutput(py.str(audioFile), py.str(['I cannot understand ' userName]));
else
    disp('MATLAB Assistant: I cannot understand');
    py.assistantRecord.speakOutput(py.str(audioFile), py.str('I cannot understand'));
end

end

