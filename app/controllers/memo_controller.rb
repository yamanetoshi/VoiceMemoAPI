class MemoController < ApplicationController

  def find_memo_list
    $redis = Redis.current

    key = 'key:'
    key << params[:id]
    key << ':*'
    ret = $redis.keys(key)

    logger.info(ret)

    render json: ret
  end

  def find_memo_detail
    $redis = Redis.current

    key = 'key:'
    key << params[:key]
    key << ':'
    key << params[:time]

    str = $redis.get(key)
    ret = { 'data' => str }
    logger.info(ret)

    render json: ret
  end

  def insert_memo
    logger.info(params)
    logger.info(params[:memo])

    @memo = params[:memo]
    $redis = Redis.current

    key = 'key:'
    key << @memo[:id]
    key << ':'
    key << Time.now.to_i.to_s
    $redis.set(key, @memo[:val])

    render json: { key => @memo[:val] }
  end

  def update_memo
    $redis = Redis.current

    key = 'key:'
    key << params[:key]
    key << ':'
    key << params[:time]

    $redis.set(key, params[:val])

    render json: { key => params[:val] }
  end

  def delete_memo
    $redis = Redis.current

    key = 'key:'
    key << params[:key]
    key << ':'
    key << params[:time]

    logger.info(key)
    $redis.del(key)

    render json: {}
  end

end
