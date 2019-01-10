%% Finite state machine implementation
% FSM for solving the navigation problem

%% Version 1
if(obj.check_event('at_goal'))
    if(~obj.is_in_state('stop'))
        [x,y,theta] = obj.state_estimate.unpack();
        fprintf('stopped at (%0.3f,%0.3f)\n', x, y);
    end
    obj.switch_to_state('stop');
else 
    if(obj.check_event('unsafe'))
        obj.switch_to_state('avoid_obstacles');
    else
        if(obj.check_event('at_obstacle') && obj.is_in_state('go_to_goal'))
            if(obj.sliding_left)
                inputs.direction = 'left';
                obj.switch_to_state('follow_wall');
                obj.set_progress_point;
            else
                inputs.direction = 'right';
                obj.switch_to_state('follow_wall');
                obj.set_progress_point;
            end
        else
            obj.switch_to_state('go_to_goal');
        end
        if(obj.progress_made && obj.is_in_state('follow_wall'))
            obj.switch_to_state('go_to_goal');
        end
    end
end

%% Version 2
