function FSMcontrol(transitionParams)
    stateFlag = transitionParams(1);
    switch stateFlag
        case -1 %% Baseline State Handler
            disp('Baseline/Start State');
            baselineState();
        case  0 %% Training State Handler
            disp('Training State');
            trainingState();
        case  1 %% Exposure State Handler
            disp('Exposure State');
            exposureState();
        case  2 %% Exit State Handler
            disp('Exit State');
            exitState();
        otherwise %% Illegal State Handler
            error('Error: Illegal state transition! Terminating in FSM...');
    end %% end of switch-case statement
end %% end of function