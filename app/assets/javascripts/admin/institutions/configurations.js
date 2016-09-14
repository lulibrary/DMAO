$(document).on("change", "select#institution_configuration_systems_configuration_cris_system_system_id", function(select) {

    $("#cris-system-configuration-values").empty();

    if ($(this).val() !== "") {

        loadConfigKeysForSystem($(this).val())

    }

    function loadConfigKeysForSystem(system_id) {

        $.ajax({
            url: "/admin/systems/cris_systems/" + system_id + '/config_keys',
            dataType: "json",
            success: function(data) {
                $.each(data, function(index, value) {
                    $("#cris-system-configuration-values").append(configKeyInput(value.id, value.name, value.display_name));
                });
            },
            error: function(data){

            }
        });

    }

    function configKeyInput(id, name, displayName) {

        var input = "<p>";
        input += "<label for='institution_configuration_cris_system_" + name + "'>" + displayName + "</label>";
        input += "<br>";
        input += "<input type='text' name='institution_configuration[systems_configuration][cris_system][configuration_key_values][" + id + "]" + "'>";
        input += "</p>" ;

        return input;

    }

});