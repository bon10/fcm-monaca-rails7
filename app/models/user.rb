class User < ApplicationRecord
  authenticates_with_sorcery!

  def self.regsiter_and_update_token(hash)
    case hash['status']
    when "new"
      Rails.logger.info "新規登録"
      register_token(hash['token'], hash['id'])
    when "change"
      Rails.logger.info "更新"
      update_token(hash['token'], hash['id'])
    else
      Rails.logger.warn "[regsiter_and_update_token] token status is not defined"
    end
  end

  def self.register_token(token, device_id)
    # TODO: 実際はログイン中のユーザーを取得(例えばdeviseの current_user )
    user = User.first

    user.token = token
    user.uid = device_id
    user.save!
    user.test_push
  end

  def self.update_token(token, device_id)
    # TODO: 実際はトークンのdevice_idからユーザーを検索して特定し、更新する
    # また、ユーザーのdevice_idが異なってもユーザーの登録がすでにある場合もある
    # これはユーザーが退会処理などでユーザー情報を削除せずにアプリをアンインストールしたり、
    #  他機種からログインしたりした場合に発生する。これも対応要。
    user = User.first

    user.token = token
    user.uid = device_id
    user.save!
    user.test_push
  end

  def test_push
    # 実際はプッシュ対象のユーザー
    user = User.first

    token = user.token
    Rails.logger.info "test push executed"
    Rails.logger.info token
    Fcm.push(token, "テスト", "トークンの登録&更新に成功しました")
  end

end
