module ApplicationHelper
  def user_signed_in?
    !session['user_id'].blank?
  end
  
  def short_month_name month
    case month
    when 1
      "Jan"
    when 2
      "FEB"
    when 3
      "Mar"
    when 4
      "Apr"
    when 5
      "May"
    when 6
      "Jun"
    when 7
      "Jul"
    when 8
      "Aug"
    when 9
      "Sept"
    when 10
      "Oct"
    when 11
      "Nov"
    when 12
      "Dec"
    end
  end
end
