function SnakeGame()
    close all
    clear all
    clc
            % Global variables
                global difficulty
                global eat
                global died
                global musicbg
                global bestScore
                global averageScore
                global averageScoreDivisor
                    
            % Checking if file exist
            %if ~isempty(bestScore) || exist('bestScore', 'var')
            %    load('snekBestScore.mat');
            %else
            %    bestScore = 0;
            %    save('snekBestScore.mat', 'bestScore');
            %end
    
    % Initialize the game
        snakeLength = 1; % Initial length
        snakePos = [randi([1, 18], 1, 1), randi([1, 18], 1, 1)];
        snakeDir = [0, randi([-1, 1], 1, 1)]; % Initial direction
        foodPos  = randi([1, 19], 1, 2); % Initial food position
        score    = 0;
        averageScoreDivisor = 0;
        bestScore = bestScore;

            fprintf('Score: [\b%d]\b\n', score)
            fprintf('Best Score: [\b%d]\b\n', bestScore)
            fprintf('Average Score: [\b%d]\b\n', averageScore)
        
        % Difficulty
        difficulty = 0.2;
        fprintf('Speed: [\bNormal]\b\n')

        % game audio
        %[e, Es] = audioread('audios\eat.wav');
        %[y, Fs] = audioread('audios\died.wav');
        %[m, Ms] = audioread('C:\Users\ADMIN\Music\Themes\The Red Army Choir - National Anthem of USSR.wav');
        %eat     = audioplayer(e, Es);
        %died    = audioplayer(y, Fs);
        %musicbg = audioplayer(m, Ms);
        %sound(m, Ms, 24);
        %stop(musicbg);

        % Circular buffer to store snake body positions
        bufferSize = 100; % Adjust the size based on the expected maximum snake length
        bodyBuffer = nan(bufferSize, 2);
        bodyBuffer(1:snakeLength, :) = repmat(snakePos, snakeLength, 1);

    % Create the figure
    fig = figure('Toolbar', 'none', 'NumberTitle', 'off', 'Name', 'Snek Game', 'KeyPressFcn', @keyPressCallback);     

   %text(0.1, 0.1, sprintf('Temperature'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'red', 'fontweight', 'bold');
    
    % Create a score text object
   % scoreText = text(0.5, 10.5, ['Score: ' num2str(score)], 'FontSize', 12, 'FontWeight', 'bold');

    % Game loop
    while ishandle(fig)
        % Move the snake
        snakePos = snakePos + snakeDir;
        
        % Check for collisions
        if snakePos(1) < 1 || snakePos(1) > 20 || snakePos(2) < 1 || snakePos(2) > 20
            %play(died);
            %clear sound;
            msgbox("Game Over - Out of bounds. Press 'R/r' to restart.", "GAME OVER!", "error");
            break;
        end
        
        % Check if snake ate its own body
        if any(ismember(bodyBuffer(1:snakeLength - 1, :), snakePos, 'rows'))
            %play(died);
            clear sound;
            msgbox("Game Over - Snake ate its own body. Press 'R/r'  to restart.", "GAME OVER!", "error");
            break;
        end
        
        % Check if snake ate the food
        if isequal(snakePos, foodPos)
            snakeLength                = snakeLength + 1;
            %play(eat);
            bodyBuffer(snakeLength, :) = snakePos;
            foodPos                    = randi([1, 18], 1, 2);
            score                      = score + 1;
            
                % Saving the best score
                if score > bestScore 
                    bestScore = score;
                    save('snekBestScore.mat', 'bestScore');
                end
            
            clc
            
                fprintf('Score: [\b%d]\b\n', score)
                fprintf('Best Score: [\b%d]\b\n', bestScore')
                fprintf('Average Score: [\b%d]\b\n', averageScore)
            
            global difficulty
           % text(0.5, 10.5, ['Score: ' num2str(score)], 'FontSize', 12, 'FontWeight', 'bold');
            
            if difficulty == 0.2
                fprintf('Speed: [\bNormal]\b\n')
            elseif difficulty == 0.3
                fprintf('Speed: [\bSlow]\b\n')
            elseif difficulty == 0.1
                fprintf('Speed: [\bFast]\b\n')
            elseif difficulty == 0
                fprintf('Speed: [\bVery Fast]\b\n')
            end
        end
        
        % Update circular buffer with new snake position
        bodyBuffer(2:end, :) = bodyBuffer(1:end - 1, :);
        bodyBuffer(1, :)     = snakePos;

        % Plot the game board
        clf;
        hold on; 
        plot(bodyBuffer(1:snakeLength, 1), bodyBuffer(1:snakeLength, 2), 's', 'MarkerSize', 8, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'green'); % Snake body
        plot(snakePos(1), snakePos(2), 'Marker', 'o', 'MarkerSize', 10,  'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'green'); % Snake head
        plot(foodPos(1), foodPos(2), 'r*', 'MarkerSize', 10); % Food
        
        axis([0 20 0 20]);
        grid off;
        % get handle to current axes
        a = gca;
        % set box property to off and remove background color
        set(a,'box','off','color','none')
        set(a,'XTick', [], 'YTick', [])
        % create new, empty axes with box but without ticks
        b = axes('Position', get(a, 'Position'), 'box', 'on', 'XTick', [], 'YTick', []);
        % set original axes as active
        axes(a)
        % link axes in case of zooming
        %linkaxes([a b])
        drawnow;
        
        % Pause for a short duration
        pause(difficulty);
    end

    % Callback function for keypress events
    function keyPressCallback(~, event)
        switch event.Key
            % movement
            case 'uparrow'
                snakeDir = [0, 1];
            case 'downarrow'
                snakeDir = [0, -1];
            case 'leftarrow'
                snakeDir = [-1, 0];
            case 'rightarrow'
                snakeDir = [1, 0];
            case{'w', 'W'}
                snakeDir = [0, 1];
            case{'s', 'S'}
                snakeDir = [0, -1];
            case{'a', 'A'}
                snakeDir = [-1, 0];
            case{'d', 'D'}
                snakeDir = [1, 0];
                
            % game options
            case{'r', 'R'}
                uiMenuRestart
            case{'x', 'X'}
                close all
                %clear all
                clear sound;
                clc
                return;
                
            % game difficulty
            case '1'
                difficulty = 0.3;
            case '2'
                difficulty = 0.2;
            case '3'
                difficulty = 0.1;
            case '4'
                difficulty = 0;
        end
    end
end

function uiMenuRestart(source, event)  
        close all
        %clear all
        clear sound;
        snek = mfilename('fullpath');
        run(snek);
end
