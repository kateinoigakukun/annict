# frozen_string_literal: true

FactoryGirl.define do
  factory :status_tip, class: Tip do
    target 0
    partial_name "status"
    title "作品のステータスを変更しよう"
    icon_name 0
  end

  factory :channel_tip, class: Tip do
    target 0
    partial_name "channel"
    title "チャンネルを設定しよう"
    icon_name 0
  end

  factory :record_tip, class: Tip do
    target 0
    partial_name "checkin"
    title "エピソードを記録しよう"
    icon_name 0
  end
end
