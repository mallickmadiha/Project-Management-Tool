module ApplicationHelper


    def current_user 
        if session[:id] != nil && session[:type] == "user"
            @current_user ||= User.find(session[:id])
        else
            @current_user = nil
        end
    end

    def logged_in?
        !current_user.nil?
    end
    

end
