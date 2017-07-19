$ ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div class="modal" id="confirmationDialog">
             <div class="modal-dialog modal-sm">
               <div class="modal-content">
                 <div class="modal-header">
                   <a class="close" data-dismiss="modal"><span class="fa fa-times"></span></a>
                   <h3>#{link.data('header') || 'Confirm, please'}</h3>
                 </div>
                 <div class="modal-body">
                   #{message}
                 </div>
                 <div class="modal-footer">
                   <a data-dismiss="modal" class="btn btn-default">
                     <b>#{link.data('cancel') || 'Cancel'}</b>
                   </a>
                   <a data-dismiss="modal" class="btn btn-danger confirm">
                     <b>#{link.data('ok') || 'Ok'}</b>
                     </a>
                 </div>
               </div>
             </div>
           </div>
           """
    $(html).modal()
    $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)