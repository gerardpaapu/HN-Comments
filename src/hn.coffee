$ = jQuery

api_root = "http://api.ihackernews.com/"
site_root = "http://news.ycombinator.com/"

embed_hn_thread = (url, element) ->
    wrapper = $('<div class="hn_comments">Loading comments&hellip;</div>')

    $(element).append(wrapper)

    get_thread_id = (url, callback) ->
        $.ajax
            url: "#{api_root}getid"
            dataType: "jsonp"
            data:
                url: url
                format: "jsonp"

            success: (data) ->
                if data.length then callback data[0]

    get_thread_by_id = (id, callback) ->
        $.ajax
            url: "#{api_root}post/#{id}"
            dataType: "jsonp"
            data: { format: "jsonp" }
            success: callback

    get_thread_by_url = (url, callback) ->
        get_thread_id url, (id) -> get_thread_by_id id, callback

    get_thread_by_url url, (thread) ->
        wrapper.html """
            <a class="threadLink" 
               href="#{site_root}item?id=#{thread.id}">
                    Comment at Hacker News
            </a>
            #{ render_comments thread.comments, thread }
            """

render_comment = (comment, thread) ->
    html = """
        <div class="comment">
            <div class="commentHead">
                #{comment.points} points by
                <a class="username" href="#{site_root}user?id=#{comment.postedBy}">
                    #{comment.postedBy}
                </a> | <a href="#{site_root}item?id=#{comment.id}">link</a>
            </div>
            <div class="commentBody">
                #{comment.comment}
            </div>
            <a class="reply"
               href="#{site_root}reply?id=#{comment.id}&whence=item%3fid%3d#{thread.id}">
               reply
            </a>
            #{ render_comments comment.children, thread }
        </div>
    """

render_comments = (comments, thread) ->
    return "" unless comments?

    items = for comment in comments
        "<li>#{ render_comment comment, thread }</li>"

    """<ul class="comments">#{ items.join '\n' }</ul>"""

$.fn.loadHNComments = (url=window.location.href) ->
    embed_hn_thread url, this
