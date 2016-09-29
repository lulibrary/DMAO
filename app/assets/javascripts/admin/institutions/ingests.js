$("#new_ingest_job").on("ajax:success", function(e, data, status, xhr) {

    var alert = '<div class="alert alert-success alert-dismissible">';
    alert += '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
    alert += '<h4><i class="icon fa fa-check"></i> Successfully added ingest!</h4>';
    alert += 'Manual ingest has been added to the system.';
    alert += '</div>';

    $("#ingest-jobs > .row > .alerts").append(alert);

});