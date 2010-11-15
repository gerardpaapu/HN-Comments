$ = jQuery

embed_hn_thread = (url, element) ->
    wrapper = $('<div class="hn_comments">Loading comments&hellip;</div>')
    $(element).append(wrapper)

    get_thread_id = (url, callback) ->
        $.ajax
            url: "http://api.ihackernews.com/getid"
            dataType: "jsonp"
            data:
                url: url
                format: "jsonp"

            success: (data) ->
                if data.length then callback data[0]

    get_thread_by_id = (id, callback) ->
        $.ajax
            url: "http://api.ihackernews.com/post/#{id}"
            dataType: "jsonp"
            data:
                format: "jsonp"

            success: callback

    get_thread_by_url = (url, callback) ->
        get_thread_id url, (id) -> get_thread_by_id id, callback

    get_thread_by_url url, (thread) ->
        wrapper.empty()
        wrapper.append """
            <a class="threadLink" 
               href="http://news.ycombinator.com/item?id=#{thread.id}">
                    Comment at Hacker News
            </a>""" # yeah ... I'm not proud of all the html 

        wrapper.append(render_comments thread.comments, thread)

render_comment = (comment, thread) ->
    html = $ '<div class="comment" />'
    head = $ '<div class="commentHead" />'
    body = $ '<div class="commentBody" />'
    head.append """
        #{comment.points} points by
        <a class="username" href="http://news.ycombinator.com/user?id=#{comment.postedBy}">
            #{comment.postedBy}
        </a> | <a href="http://news.ycombinator.com/item?id=#{comment.id}">link</a>
        """
    body.append comment.comment
    html.append head
    html.append body
    html.append """
    <a class="reply"
       href="http://news.ycombinator.com/reply?id=#{comment.id}&whence=item%3fid%3d#{thread.id}">
       reply
    </a>
    """

    if comment.children?
        html.append render_comments comment.children, thread

    html

render_comments = (comments, thread) ->
    list = $ '<ul class="comments" />'

    for comment in comments
        item = $ '<li />'
        item.append render_comment comment, thread
        list.append item

    list

jQuery.fn.loadHNComments = (url) ->
    url ?= window.location.href
    embed_hn_thread url, this
