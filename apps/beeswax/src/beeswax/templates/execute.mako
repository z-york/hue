## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
  from desktop.lib.django_util import extract_field_data
  from desktop.views import commonheader, commonfooter
  from django.utils.translation import ugettext as _
%>

<%namespace name="comps" file="beeswax_components.mako" />
<%namespace name="layout" file="layout.mako" />

${ commonheader(_('Query'), app_name, user) | n,unicode }
${layout.menubar(section='query')}

<div id="query-editor" class="container-fluid hide section">
<div class="row-fluid">
<div class="span2">
  <form id="advancedSettingsForm" action="${action}" method="POST" class="form form-horizontal">
    <div class="sidebar-nav">
      <ul class="nav nav-list">
        <li class="nav-header">${_('database')}</li>
        <li class="white">
          <select data-bind="options: databases, value: database" class="input-medium" name="query-database"></select>
        </li>
        <li class="nav-header">${_('settings')}</li>
        <li class="white">
          <!-- ko foreach: query.settings -->
          <div class="param">
            <div class="remove">
              <button data-bind="click: $root.removeSetting.bind(this, $index())" type="button"
                      class="btn btn-mini settingsDelete" title="${_('Delete this setting')}">x
              </button>
            </div>
            <div class="control-group">
              <label>${_('Key')}</label>
              <input data-bind="value: key" type="text" class="settingsField span8" autocomplete="off"
                     placeholder="mapred.reduce.tasks"/>
            </div>

            <div class="control-group">
              <label>${_('Value')}</label>
              <input data-bind="value: value" type="text" class="span8" placeholder="1"/>
            </div>
          </div>
          <!-- /ko -->

          <div class="control-group">
            <a data-bind="click: function() { $root.addSetting('','') }" class="btn btn-small">${_('Add')}</a>
          </div>
        </li>
        <li class="nav-header
              % if app_name == 'impala':
                                   hide
                                                 % endif
              ">
          ${_('File Resources')}
        </li>
        <li class="white
              % if app_name == 'impala':
                                   hide
                                                 % endif
              ">
          <!-- ko foreach: query.fileResources -->
          <div class="param">
            <div class="remove">
              <button data-bind="click: $root.removeFileResources.bind(this, $index())" type="button"
                      class="btn btn-mini file_resourcesDelete" title="${_('Delete this setting')}">x
              </button>
            </div>
            <div class="control-group">
              <label>${_('Type')}</label>
              <select data-bind="value: type" class="input-medium">
                <option value="JAR">${_('jar')}</option>
                <option value="ARCHIVE">${_('archive')}</option>
                <option value="FILE">${_('file')}</option>
              </select>
            </div>

            <div class="control-group">
              <label>${_('Path')}</label>
              <input data-bind="value: path" type="text" class="input-medium file_resourcesField pathChooser"
                     placeholder="/user/foo/udf.jar"/>
            </div>
          </div>
          <!-- /ko -->

          <div class="control-group">
            <a data-bind="click: function() { $root.addFileResources('','') }" class="btn btn-small">${_('Add')}</a>
          </div>
        </li>
        <li class="nav-header
            % if app_name == 'impala':
                                 hide
                                             % endif
            ">
          ${_('User-defined Functions')}
        </li>
        <li class="white
            % if app_name == 'impala':
                                 hide
                                             % endif
            ">
          <!-- ko foreach: query.functions -->
          <div class="param">
            <div class="remove">
              <button data-bind="click: $root.removeFunction.bind(this, $index())" type="button"
                      class="btn btn-mini settingsDelete" title="${_('Delete this setting')}">x
              </button>
            </div>
            <div class="control-group">
              <label>${_('Name')}</label>
              <input data-bind="value: name" type="text" class="functionsField span8" autocomplete="off"
                     placeholder="myFunction"/>
            </div>

            <div class="control-group">
              <label>${_('Class name')}</label>
              <input data-bind="value: class_name" type="text" class="span8" placeholder="com.acme.example"/>
            </div>
          </div>
          <!-- /ko -->

          <div class="control-group">
            <a data-bind="click: function() { $root.addFunction('','') }" class="btn btn-small">${_('Add')}</a>
          </div>
        </li>
        <li class="nav-header">${_('Parameterization')}</li>
        <li class="white">
          <label class="checkbox" rel="tooltip"
                 data-original-title="${_("If checked (the default), you can include parameters like $parameter_name in your query, and users will be prompted for a value when the query is run.")}">
            <input data-bind="checked: query.isParameterized" type="checkbox"/>
            ${_("Enable Parameterization")}
          </label>
        </li>
        <li class="nav-header
                % if app_name == 'impala':
                                     hide
                                                     % endif
              ">${_('Email Notification')}</li>
        <li class="white
                % if app_name == 'impala':
                                     hide
                                                     % endif
              ">
          <label class="checkbox" rel="tooltip"
                 data-original-title="${_("If checked, you will receive an email notification when the query completes.")}">
            <input data-bind="checked: query.email" type="checkbox"/>
            ${_("Email me on completion.")}
          </label>
        </li>
        % if app_name == 'impala':
          <li class="nav-header">
            ${_('Metastore Catalog')}
          </li>
          <li class="white">
            <div class="control-group">
                  <span id="refresh-dyk">
                    <i class="fa fa-refresh"></i>
                    ${ _('Sync tables tips') }
                  </span>

              <div id="refresh-content" class="hide">
                <ul style="text-align: left;">
                  <li>"invalidate
                    metadata" ${ _("invalidates the entire catalog metadata. All table metadata will be reloaded on the next access.") }</li>
                  <li>"invalidate metadata
                    &lt;table&gt;" ${ _("invalidates the metadata, load on the next access") }</li>
                  <li>"refresh
                    &lt;table&gt;" ${ _("refreshes the metadata immediately. It is a faster, incremental refresh.") }</li>
                </ul>
              </div>
            </div>
          </li>
        % endif
        <li class="nav-header"></li>
        <li class="white">
          <div class="control-group">
            <i class="fa fa-question-circle" id="help"></i>

            <div id="help-content" class="hide">
              <ul style="text-align: left;">
                <li>${ _('Press CTRL + Space to autocomplete') }</li>
                <li>${ _("You can execute queries with multiple SQL statements delimited by a semicolon ';'") }</li>
                <li>${ _('You can highlight and run a fragment of a query') }</li>
              </ul>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </form>
</div>

<div id="querySide" class="span8">
  <div class="card card-small">
    <div style="margin-bottom: 30px">
      <h1 class="card-heading simple">
        ${ _('Query Editor') }
        % if can_edit_name:
          :
          <a href="javascript:void(0);"
             id="query-name"
             data-type="text"
             data-name="name"
             data-value="${design.name}"
             data-original-title="${ _('Query name') }"
             data-placement="right">
          </a>
        %endif
        <span data-bind="visible: $root.isRunning()">
          <!--[if !IE]><!--><i class="fa fa-spinner fa-spin" style="font-size: 20px; color: #999"></i><!--<![endif]-->
          <!--[if IE]><img src="/static/art/spinner.gif"/><![endif]-->
        </span>
      </h1>
      % if can_edit_name:
        <p style="margin-left: 20px">
          <a href="javascript:void(0);"
             id="query-description"
             data-type="textarea"
             data-name="description"
             data-value="${design.desc}"
             data-original-title="${ _('Query description') }"
             data-placement="right">
          </a>
        </p>
      % endif
    </div>
    <div class="card-body">
      <div class="tab-content">
        <div id="queryPane">

          <div data-bind="css: {'hide': query.errors().length == 0}" class="hide alert alert-error">
            <p><strong>${_('Your query has the following error(s):')}</strong></p>

            <div data-bind="foreach: query.errors">
              <p data-bind="text: $data" class="queryErrorMessage"></p>
            </div>
          </div>

          <textarea class="hide" tabindex="1" name="query" id="queryField"></textarea>

          <div class="actions">
            <button data-bind="click: tryExecuteQuery, visible: !$root.isRunning()" type="button" id="executeQuery"
                    class="btn btn-primary" tabindex="2">${_('Execute')}</button>
            <button data-bind="click: tryCancelQuery, visible: $root.isRunning()" class="btn btn-danger"
                    data-loading-text="${ _('Canceling...') }" rel="tooltip"
                    data-original-title="${ _('Cancel the query') }">${ _('Cancel') }</button>
            <button data-bind="click: trySaveQuery, css: {'hide': !$root.query.id() || $root.query.id() == -1}"
                    type="button" class="btn hide">${_('Save')}</button>
            <button data-bind="click: saveAsModal" type="button" class="btn">${_('Save as...')}</button>
            <button data-bind="click: tryExplainQuery" type="button" id="explainQuery"
                    class="btn">${_('Explain')}</button>
            &nbsp; ${_('or create a')} &nbsp;<a type="button" class="btn"
                                                href="${ url('beeswax:execute_query') }">${_('New query')}</a>
            <br/><br/>
          </div>

        </div>
      </div>
    </div>
  </div>

  <div class="card card-small scrollable resultsContainer">
    <a id="expandResults" href="javascript:void(0)" class="view-query-results hide pull-right"><h4 style="margin-right: 20px"><i class="fa fa-expand"></i></h4></a>
    <div class="card-body">
      <ul class="nav nav-tabs">
        <!-- ko if: !query.explain() -->
        <li><a href="#log" data-toggle="tab">${_('Log')}</a></li>
        <!-- /ko -->
        <li><a href="#query" data-toggle="tab">${_('Query')}</a></li>
        <!-- ko if: !query.explain() -->
        <li><a href="#results" data-toggle="tab">${_('Results')}</a></li>
        <!-- /ko -->
        <!-- ko if: query.explain() -->
        <li><a href="#explanation" data-toggle="tab">${_('Explanation')}</a></li>
        <!-- /ko -->
      </ul>

      <div class="tab-content">
        <div class="tab-pane" id="query">
          <pre data-bind="text: viewModel.query.query()"></pre>
        </div>
        <!-- ko if: query.explain() -->
        <div class="tab-pane" id="explanation">
          <pre data-bind="text: viewModel.explanation()"></pre>
        </div>
        <!-- /ko -->
        <!-- ko if: !query.explain() -->
        <div class="active tab-pane" id="log">
          <pre data-bind="text: viewModel.logs().join('\n')"></pre>
        </div>
        <div class="tab-pane" id="results">
          <div data-bind="css: {'hide': rows().length == 0}" class="hide">
            <table class="table table-striped table-condensed resultTable" cellpadding="0" cellspacing="0"
                   data-tablescroller-min-height-disable="true" data-tablescroller-enforce-height="true">
              <thead>
              <tr data-bind="foreach: columns">
                <th data-bind="text: $data"></th>
              </tr>
              </thead>
            </table>
          </div>

          <div data-bind="css: {'hide': !resultsEmpty()}" class="hide">
            <div class="card card-small scrollable">
              <div class="row-fluid">
                <div class="span10 offset1 center empty-wrapper">
                  <i class="fa fa-frown-o"></i>

                  <h1>${_('The server returned no results.')}</h1>
                  <br/>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /ko -->
      </div>
    </div>
  </div>
</div>

<div class="span2" id="navigator">
  <div class="card card-small">
    <a href="#" title="${_('Double click on a table name or field to insert it in the editor')}" rel="tooltip"
       data-placement="left" class="pull-right" style="margin:10px;margin-left: 0"><i class="fa fa-question-circle"></i></a>
    <a id="refreshNavigator" href="#" title="${_('Manually refresh the table list')}" rel="tooltip"
       data-placement="left" class="pull-right" style="margin:10px"><i class="fa fa-refresh"></i></a>

    <h1 class="card-heading simple"><i class="fa fa-compass"></i> ${_('Navigator')}</h1>

    <div class="card-body">
      <p>
        <input id="navigatorSearch" type="text" placeholder="${ _('Table name...') }" style="width:90%"/>
        <span id="navigatorNoTables">${_('The selected database has no tables.')}</span>
      <ul id="navigatorTables" class="unstyled"></ul>
      <div id="navigatorLoader">
        <!--[if !IE]><!--><i class="fa fa-spinner fa-spin" style="font-size: 20px; color: #DDD"></i><!--<![endif]-->
        <!--[if IE]><img src="/static/art/spinner.gif"/><![endif]-->
      </div>
      </p>
    </div>
  </div>
</div>
</div>
</div>


<div id="execute-parameter-selection" class="container-fluid hide section">
  <div class="row-fluid">
    <div class="card card-small">
      <h1 class="card-heading simple">${_('Please specify parameters for this query')}</h1>

      <div class="card-body">
        <p>

        <form method="POST" action="" class="form-horizontal">
          <fieldset>
            <!-- ko foreach: $root.query.parameters -->
            <div class="control-group">
              <label data-bind="text: name" class="control-label"></label>

              <div class="controls">
                <input data-bind="value: value" type="text"/>
              </div>
            </div>
            <!-- /ko -->
            <div class="form-actions" style="padding-left: 10px">
              <a class="btn" href="javascript:history.go(-1);">${_('Cancel')}</a>
              <button data-bind="click: tryExecuteParameterizedQuery" type="button"
                      class="btn btn-primary">${_('Execute query')}</button>
            </div>
          </fieldset>
        </form>
        </p>
      </div>
    </div>
  </div>
</div>


<div id="explain-parameter-selection" class="container-fluid hide section">
  <div class="row-fluid">
    <div class="card card-small">
      <h1 class="card-heading simple">${_('Please specify parameters for this query')}</h1>

      <div class="card-body">
        <p>

        <form method="POST" action="" class="form-horizontal">
          <fieldset>
            <!-- ko foreach: $root.query.parameters -->
            <div class="control-group">
              <label data-bind="text: name" class="control-label"></label>

              <div class="controls">
                <input data-bind="value: value" type="text"/>
              </div>
            </div>
            <!-- /ko -->
            <div class="form-actions" style="padding-left: 10px">
              <a class="btn" href="javascript:history.go(-1);">${_('Cancel')}</a>
              <button data-bind="click: tryExplainParameterizedQuery" type="button"
                      class="btn btn-primary">${_('Explain query')}</button>
            </div>
          </fieldset>
        </form>
        </p>
      </div>
    </div>
  </div>
</div>


<div id="chooseFile" class="modal hide fade">
  <div class="modal-header">
    <a href="#" class="close" data-dismiss="modal">&times;</a>

    <h3>${_('Choose a file')}</h3>
  </div>
  <div class="modal-body">
    <div id="filechooser">
    </div>
  </div>
  <div class="modal-footer">
  </div>
</div>

<div id="saveAs" class="modal hide fade">
  <div class="modal-header">
    <a href="#" class="close" data-dismiss="modal">&times;</a>

    <h3>${_('Choose a name')}</h3>
  </div>
  <form class="form-horizontal">
    <div class="control-group" id="saveas-query-name">
      <label class="control-label">${_('Name')}</label>

      <div class="controls">
        <input data-bind="value: $root.query.name" type="text" class="input-xlarge">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">${_('Description')}</label>

      <div class="controls">
        <input data-bind="value: $root.query.description" type="text" class="input-xlarge">
      </div>
    </div>
  </form>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal">${_('Cancel')}</button>
    <button data-bind="click: trySaveAsQuery" class="btn btn-primary">${_('Save')}</button>
  </div>
</div>

<div id="navigatorQuicklook" class="modal hide fade">
  <div class="modal-header">
    <a href="#" class="close" data-dismiss="modal">&times;</a>
    <a class="tableLink pull-right" href="#" target="_blank" style="margin-right: 20px;margin-top:6px"><i
        class="fa fa-external-link"></i> ${ _('View in Metastore Browser') }</a>

    <h3>${_('Data sample for')} <span class="tableName"></span></h3>
  </div>
  <div class="modal-body" style="min-height: 100px">
    <div class="loader">
      <!--[if !IE]><!--><i class="fa fa-spinner fa-spin" style="font-size: 30px; color: #DDD"></i><!--<![endif]-->
      <!--[if IE]><img src="/static/art/spinner.gif"/><![endif]-->
    </div>
    <div class="sample"></div>
  </div>
  <div class="modal-footer">
    <button class="btn btn-primary disable-feedback" data-dismiss="modal">${_('Ok')}</button>
  </div>
</div>

<script src="/static/ext/js/routie-0.3.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/ext/js/knockout-min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/ext/js/knockout.mapping-2.3.2.js" type="text/javascript" charset="utf-8"></script>
<script src="/beeswax/static/js/beeswax.vm.js"></script>
<script src="/static/ext/js/codemirror-3.11.js"></script>
<link rel="stylesheet" href="/static/ext/css/codemirror.css">
<script src="/static/js/codemirror-hql.js"></script>
% if app_name == 'impala':
  <script src="/static/js/codemirror-isql-hint.js"></script>
% else:
  <script src="/static/js/codemirror-hql-hint.js"></script>
% endif
<script src="/static/js/codemirror-show-hint.js"></script>

<link href="/static/ext/css/bootstrap-editable.css" rel="stylesheet">
<script src="/static/ext/js/bootstrap-editable.min.js"></script>

<style type="text/css">
  h1 {
    margin-bottom: 5px;
  }

  #filechooser {
    min-height: 100px;
    overflow-y: auto;
  }

  .control-group {
    margin-bottom: 3px !important;
  }

  .control-group label {
    float: left;
    padding-top: 5px;
    text-align: left;
    width: 40px;
  }

  .sidebar-nav {
    margin-bottom: 90px !important;
  }

  .param {
    padding: 8px 8px 1px 8px;
    margin-bottom: 5px;
    border-bottom: 1px solid #EEE;
  }

  .remove {
    float: right;
  }

  .file_resourcesField {
    border-radius: 3px 0 0 3px;
    border-right: 0 !important;
    min-height: 27px !important;
  }

  .fileChooserBtn {
    border-radius: 0 3px 3px 0;
  }

  .CodeMirror {
    border: 1px solid #eee;
    margin-bottom: 20px;
  }

  .editorError {
    color: #B94A48;
    background-color: #F2DEDE;
    padding: 4px;
    font-size: 11px;
  }

  .editable-empty, .editable-empty:hover {
    color: #666;
    font-style: normal;
  }

  #navigatorTables li {
    width: 95%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  #navigatorSearch, #navigatorNoTables {
    display: none;
  }

  .tooltip.left {
    margin-left: -13px;
  }

  .fullscreen {
    position: absolute;
    top: 70px;
    left: 0;
    width: 100%;
    background-color: #FFFFFF;
    z-index: 32000;
  }

</style>

<script src="/static/ext/js/jquery/plugins/jquery-fieldselection.js" type="text/javascript"></script>
<script src="/beeswax/static/js/autocomplete.utils.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" charset="utf-8">
var codeMirror, renderNavigator, resetNavigator, dataTable;

var HIVE_AUTOCOMPLETE_BASE_URL = "${ autocomplete_base_url | n,unicode }";
var HIVE_AUTOCOMPLETE_FAILS_SILENTLY_ON = [500]; // error codes from beeswax/views.py - autocomplete

var HIVE_AUTOCOMPLETE_GLOBAL_CALLBACK = function (data) {
  if (data != null && data.error) {
    resetNavigator();
  }
};

// Navigator.
$(document).ready(function () {

  $("#navigatorQuicklook").modal({
    show: false
  });

  var navigatorSearchTimeout = -1;
  $("#navigatorSearch").on("keyup", function () {
    window.clearTimeout(navigatorSearchTimeout);
    navigatorSearchTimeout = window.setTimeout(function () {
      $("#navigatorTables li").removeClass("hide");
      $("#navigatorTables li").each(function () {
        if ($(this).text().toLowerCase().indexOf($("#navigatorSearch").val().toLowerCase()) == -1) {
          $(this).addClass("hide");
        }
      });
    }, 300);
  });

  resetNavigator = function () {
    var _db = viewModel.database();
    if (_db != null) {
      $.totalStorage('tables_' + _db, null);
      $.totalStorage('timestamp_tables_' + _db, null);
      renderNavigator();
    }
  }

  renderNavigator = function () {
    $("#navigatorTables").empty();
    $("#navigatorLoader").show();
    hac_getTables(viewModel.database(), function (data) {  //preload tables for the default db
      $(data.split(" ")).each(function (cnt, table) {
        if ($.trim(table) != "") {
          var _table = $("<li>");
          _table.html("<a href='/metastore/table/" + viewModel.database() + "/" + table + "' target='_blank' class='pull-right'><i class='fa fa-eye' title='" + "${ _('View in Metastore Browser') }" + "' style='margin-left:5px'></i></a><a href='#' class='pull-right hide'><i class='fa fa-list' title='" + "${ _('Preview Sample data') }" + "'></i></a><a href='#' title='" + table + "'><i class='fa fa-table'></i> " + table + "</a><ul class='unstyled'></ul>");
          _table.data("table", table).attr("id", "navigatorTables_" + table);
          _table.find("a:eq(2)").on("click", function () {
            _table.find(".fa-table").removeClass("fa-table").addClass("fa-spin").addClass("fa-spinner");
            hac_getTableColumns(viewModel.database(), table, "", function (plain_columns, extended_columns) {
              _table.find("a:eq(1)").removeClass("hide");
              _table.find("ul").empty();
              _table.find(".fa-spinner").removeClass("fa-spinner").removeClass("fa-spin").addClass("fa-table");
              $(extended_columns).each(function (iCnt, col) {
                var _column = $("<li>");
                _column.html("<a href='#' style='padding-left:10px'" + (col.comment != null && col.comment != "" ? " title='" + col.comment + "'" : "") + "><i class='fa fa-columns'></i> " + col.name + " (" + col.type + ")</a>");
                _column.appendTo(_table.find("ul"));
                _column.on("dblclick", function () {
                  codeMirror.replaceSelection($.trim(col.name) + ', ');
                  codeMirror.setSelection(codeMirror.getCursor());
                  codeMirror.focus();
                });
              });
            });
          });
          _table.find("a:eq(2)").on("dblclick", function () {
            codeMirror.replaceSelection($.trim(table) + ' ');
            codeMirror.setSelection(codeMirror.getCursor());
            codeMirror.focus();
          });
          _table.find("a:eq(1)").on("click", function () {
            $("#navigatorQuicklook").find(".tableName").text(table);
            $("#navigatorQuicklook").find(".tableLink").attr("href", "/metastore/table/" + viewModel.database() + "/" + _table.data("table"));
            $("#navigatorQuicklook").find(".sample").empty("");
            $("#navigatorQuicklook").attr("style", "width: " + ($(window).width() - 120) + "px;margin-left:-" + (($(window).width() - 80) / 2) + "px!important;");
            $.ajax({
              url: "/metastore/table/" + viewModel.database() + "/" + _table.data("table"),
              data: {"sample": true},
              beforeSend: function (xhr) {
                xhr.setRequestHeader("X-Requested-With", "Hue");
              },
              dataType: "html",
              success: function (data) {
                $("#navigatorQuicklook").find(".loader").hide();
                $("#navigatorQuicklook").find(".sample").html(data);
              },
              error: function (e) {
                if (e.status == 500) {
                  resetNavigator();
                  $(document).trigger("error", "${ _('There was a problem loading the table preview.') }");
                  $("#navigatorQuicklook").modal("hide");
                }
              }
            });
            $("#navigatorQuicklook").modal("show");
          });
          _table.appendTo($("#navigatorTables"));
        }
      });
      $("#navigatorLoader").hide();
      if ($("#navigatorTables li").length > 0) {
        $("#navigatorSearch").show();
        $("#navigatorNoTables").hide();
      }
      else {
        $("#navigatorSearch").hide();
        $("#navigatorNoTables").show();
      }
    });
  }

  $("#expandResults").on("click", function(){
    if ($(this).find("i").hasClass("fa-expand")){
      $(this).find("i").removeClass("fa-expand").addClass("fa-compress");
      $(this).parent().addClass("fullscreen");
    }
    else {
      $(this).find("i").addClass("fa-expand").removeClass("fa-compress");
      $(this).parent().removeClass("fullscreen");
    }
    reinitializeTable();
  });

  renderNavigator();

  $("#refreshNavigator").on("click", function () {
    resetNavigator();
  });


  $("#navigator .card").css("min-height", ($(window).height() - 130) + "px");
  $("#navigatorTables").css("max-height", ($(window).height() - 260) + "px").css("overflow-y", "auto");

  viewModel.database.subscribe(function () {
    renderNavigator();
  });
});


// Codemirror query field
function getHighlightedQuery() {
  var selection = codeMirror.getSelection();
  if (selection != "") {
    return selection;
  }
  return null;
}

function reinitializeTable () {
  window.setTimeout(function(){
    $(".dataTables_wrapper").jHueTableScroller({
      heightAfterCorrection: 0
    });
    $(".resultTable").jHueTableExtender({
      hintElement: "#jumpToColumnAlert",
      fixedHeader: true,
      firstColumnTooltip: true
    });
  }, 400)
}

$(document).ready(function () {
  var queryPlaceholder = "${_('Example: SELECT * FROM tablename, or press CTRL + space')}";

  $("#executeQuery").tooltip({
    title: '${_("Press \"tab\", then \"enter\".")}'
  });

  $("#executeQuery").keyup(function (event) {
    if (event.keyCode == 13) {
      tryExecuteQuery();
    }
  });

  initQueryField();

  var resizeTimeout = -1;
  var winWidth = $(window).width();
  var winHeight = $(window).height();

  $(window).on("resize", function () {
    window.clearTimeout(resizeTimeout);
    resizeTimeout = window.setTimeout(function () {
      // prevents endless loop in IE8
      if (winWidth != $(window).width() || winHeight != $(window).height()) {
        $("#navigator .card").css("min-height", ($(window).height() - 130) + "px");
        $("#navigatorTables").css("max-height", ($(window).height() - 260) + "px").css("overflow-y", "auto");
        winWidth = $(window).width();
        winHeight = $(window).height();
      }
    }, 200);
  });

  function initQueryField() {
    if ($("#queryField").val() == "") {
      $("#queryField").val(queryPlaceholder);
    }
  }

  var queryEditor = $("#queryField")[0];

  % if app_name == 'impala':
    var AUTOCOMPLETE_SET = CodeMirror.impalaSQLHint;
  % else:
    var AUTOCOMPLETE_SET = CodeMirror.hiveQLHint;
  % endif

  CodeMirror.onAutocomplete = function (data, from, to) {
    if (CodeMirror.tableFieldMagic) {
      codeMirror.replaceRange(" ", from, from);
      codeMirror.setCursor(from);
      codeMirror.execCommand("autocomplete");
    }
  };

  CodeMirror.commands.autocomplete = function (cm) {
    $(document.body).on("contextmenu", function (e) {
      e.preventDefault(); // prevents native menu on FF for Mac from being shown
    });

    var pos = cm.cursorCoords();
    $("<i class='fa fa-spinner fa-spin CodeMirror-spinner'></i>").css("top", pos.top + "px").css("left", (pos.left - 4) + "px").appendTo($("body"));

    if ($.totalStorage('tables_' + viewModel.database()) == null) {
      CodeMirror.showHint(cm, AUTOCOMPLETE_SET);
      hac_getTables(viewModel.database(), function () {
      }); // if preload didn't work, tries again
    }
    else {
      hac_getTables(viewModel.database(), function (tables) {
        CodeMirror.catalogTables = tables;
        var _before = codeMirror.getRange({line: 0, ch: 0}, {line: codeMirror.getCursor().line, ch: codeMirror.getCursor().ch}).replace(/(\r\n|\n|\r)/gm, " ");
        CodeMirror.possibleTable = false;
        CodeMirror.tableFieldMagic = false;
        if (_before.toUpperCase().indexOf(" FROM ") > -1 && _before.toUpperCase().indexOf(" ON ") == -1 && _before.toUpperCase().indexOf(" WHERE ") == -1 ||
            _before.toUpperCase().indexOf("REFRESH") > -1 || _before.toUpperCase().indexOf("METADATA") > -1) {
          CodeMirror.possibleTable = true;
        }
        CodeMirror.possibleSoloField = false;
        if (_before.toUpperCase().indexOf("SELECT ") > -1 && _before.toUpperCase().indexOf(" FROM ") == -1 && !CodeMirror.fromDot) {
          if (codeMirror.getValue().toUpperCase().indexOf("FROM ") > -1) {
            fieldsAutocomplete(cm);
          }
          else {
            CodeMirror.tableFieldMagic = true;
            CodeMirror.showHint(cm, AUTOCOMPLETE_SET);
          }
        }
        else {
          if (_before.toUpperCase().indexOf("WHERE ") > -1 && !CodeMirror.fromDot && _before.match(/ON|GROUP|SORT/) == null) {
            fieldsAutocomplete(cm);
          }
          else {
            CodeMirror.showHint(cm, AUTOCOMPLETE_SET);
          }
        }
      });
    }
  }

  function fieldsAutocomplete(cm) {
    CodeMirror.possibleSoloField = true;
    try {
      var _possibleTables = $.trim(codeMirror.getValue(" ").substr(codeMirror.getValue().toUpperCase().indexOf("FROM ") + 4)).split(" ");
      var _foundTable = "";
      for (var i = 0; i < _possibleTables.length; i++) {
        if ($.trim(_possibleTables[i]) != "" && _foundTable == "") {
          _foundTable = _possibleTables[i];
        }
      }
      if (_foundTable != "") {
        if (hac_tableHasAlias(_foundTable, codeMirror.getValue())) {
          CodeMirror.possibleSoloField = false;
          CodeMirror.showHint(cm, AUTOCOMPLETE_SET);
        }
        else {
          hac_getTableColumns(viewModel.database(), _foundTable, codeMirror.getValue(),
              function (columns) {
                CodeMirror.catalogFields = columns;
                CodeMirror.showHint(cm, AUTOCOMPLETE_SET);
              });
        }
      }
    }
    catch (e) {
    }
  }

  CodeMirror.fromDot = false;

  codeMirror = CodeMirror(function (elt) {
    queryEditor.parentNode.replaceChild(elt, queryEditor);
  }, {
    value: queryEditor.value,
    readOnly: false,
    lineNumbers: true,
    mode: "text/x-hiveql",
    extraKeys: {
      "Ctrl-Space": function () {
        CodeMirror.fromDot = false;
        codeMirror.execCommand("autocomplete");
      },
      Tab: function (cm) {
        $("#executeQuery").focus();
      }
    },
    onKeyEvent: function (e, s) {
      if (s.type == "keyup") {
        if (s.keyCode == 190) {
          var _line = codeMirror.getLine(codeMirror.getCursor().line);
          var _partial = _line.substring(0, codeMirror.getCursor().ch);
          var _table = _partial.substring(_partial.lastIndexOf(" ") + 1, _partial.length - 1);
          if (codeMirror.getValue().toUpperCase().indexOf("FROM") > -1) {
            hac_getTableColumns(viewModel.database(), _table, codeMirror.getValue(), function (columns) {
              var _cols = columns.split(" ");
              for (var col in _cols) {
                _cols[col] = "." + _cols[col];
              }
              CodeMirror.catalogFields = _cols.join(" ");
              CodeMirror.fromDot = true;
              window.setTimeout(function () {
                codeMirror.execCommand("autocomplete");
              }, 100);  // timeout for IE8
            });
          }
        }
      }
    }
  });

  codeMirror.on("focus", function () {
    if (codeMirror.getValue() == queryPlaceholder) {
      codeMirror.setValue("");
    }
    if (errorWidget) {
      errorWidget.clear();
    }
    $("#validationResults").empty();
  });

  % if design and not design.id:
    if ($.totalStorage("${app_name}_temp_query") != null && $.totalStorage("${app_name}_temp_query") != "") {
      codeMirror.setValue($.totalStorage("${app_name}_temp_query"));
    }
  % endif

  codeMirror.on("blur", function () {
    $(document.body).off("contextmenu");
  });

  codeMirror.on("change", function () {
    $(".query").val(codeMirror.getValue());
    $.totalStorage("${app_name}_temp_query", codeMirror.getValue());
  });
});


$(document).one('fetched.query', function () {
  // Edit query name and description.
  $("#query-name").editable({
    validate: function (value) {
      if ($.trim(value) == '') {
        return "${ _('This field is required.') }";
      }
    },
    success: function (response, newValue) {
      viewModel.query.name(newValue);
    },
    emptytext: "${ _('Query name') }"
  });

  $("#query-description").editable({
    success: function (response, newValue) {
      viewModel.query.description(newValue);
    },
    emptytext: "${ _('Empty description') }"
  });
});


// Logs
$(document).ready(function () {
  var labels = {
    MRJOB: "${_('MR Job')}",
    MRJOBS: "${_('MR Jobs')}"
  };

  var logsAtEnd = true;

  $(window).resize(function () {
    resizeLogs();
  });

  $("a[href='#log']").on("shown", function () {
    resizeLogs();
  });

  $("a[data-toggle='tab']").on('shown', function (e) {
    if ($(e.target).attr("href") != "#results"){
      $($(e.target).attr("href")).height($(".dataTables_wrapper").height());
    }
    else {
      reinitializeTable();
    }
  });

  $("#log pre").scroll(function () {
    if ($(this).scrollTop() + $(this).height() + 20 >= $(this)[0].scrollHeight) {
      logsAtEnd = true;
    }
    else {
      logsAtEnd = false;
    }
  });

  function resizeLogs() {
    // Use fixed subtraction since logs aren't always visible.
    //$("#log pre").css("overflow", "auto").height($("#log").height() - 20);
    $("#log").css("overflow", "auto").height($(window).height() - $("#log").offset().top - 60);
    $("#log pre").css("overflow", "auto").height($(window).height() - $("#log pre").offset().top - 40);
  }
});


// Result Datatable
function cleanResultsTable() {
  if (dataTable) {
    dataTable.fnClearTable();
    dataTable.fnDestroy();
    viewModel.columns.valueHasMutated();
    viewModel.rows.valueHasMutated();
    dataTable = null;
  }
}

function addResults(viewModel, dataTable, index, pageSize) {
  if (viewModel.hasMoreResults() && index + pageSize > viewModel.rows().length) {
    $(document).one('fetched.results', function () {
      $.totalStorage("${app_name}_temp_query", null);
      dataTable.fnAddData(viewModel.rows.slice(index, index + pageSize));
    });
    viewModel.fetchResults();
  } else {
    dataTable.fnAddData(viewModel.rows.slice(index, index + pageSize));
  }
}

function resultsTable() {
  if (!dataTable) {
    dataTable = $(".resultTable").dataTable({
      "bPaginate": false,
      "bLengthChange": false,
      "bInfo": false,
      "bAutoWidth": false,
      "oLanguage": {
        "sEmptyTable": "${_('No data available')}",
        "sZeroRecords": "${_('No matching records')}"
      },
      "fnDrawCallback": function (oSettings) {
        reinitializeTable();
      },
      "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
        // Make sure null values are seen as NULL.
        for (var j = 0; j < aData.length; ++j) {
          if (aData[j] == null) {
            $(nRow).find('td:eq(' + j + ')').html("NULL");
          }
        }
        return nRow;
      }
    });
    $(".dataTables_filter").hide();
    reinitializeTable();

    // Automatic results grower
    var dataTableEl = $(".dataTables_wrapper");
    var index = 0;
    var pageSize = 100;
    dataTableEl.on("scroll", function (e) {
      if (dataTableEl.scrollTop() + dataTableEl.outerHeight() + 20 > dataTableEl[0].scrollHeight && dataTable) {
        dataTableEl.animate({opacity: '0.55'}, 200);
        $(".spinner").show();
        addResults(viewModel, dataTable, index, pageSize);
        index += pageSize;
        $(".spinner").hide();
        dataTableEl.animate({opacity: '1'}, 50);
      }
    });
    addResults(viewModel, dataTable, index, pageSize);
    index += pageSize;
  }
}

$(document).on('execute.query', cleanResultsTable);
$(document).on('explain.query', cleanResultsTable);
$(document).on('fetched.results', resultsTable);

var selectedLine = -1;
var errorWidget = null;
$(document).on('error.query', function () {
  if ($(".queryErrorMessage").length > 0) {
    var err = $(".queryErrorMessage").text().toLowerCase();
    var firstPos = err.indexOf("line");
    if (firstPos > -1) {
      selectedLine = $.trim(err.substring(err.indexOf(" ", firstPos), err.indexOf(":", firstPos))) * 1;
      errorWidget = codeMirror.addLineWidget(selectedLine - 1, $("<div>").addClass("editorError").html("<i class='fa fa-exclamation-circle'></i> " + err)[0], {coverGutter: true, noHScroll: true})
    }
  }
});


// Save
function trySaveQuery() {
  var query = getHighlightedQuery() || codeMirror.getValue();
  viewModel.query.query(query);
  if (viewModel.query.id() && viewModel.query.id() != -1) {
    viewModel.saveQuery();
  }
}

function trySaveAsQuery() {
  if (viewModel.query.query() && viewModel.query.name()) {
    viewModel.query.id(-1);
    viewModel.saveQuery();
    $('#saveas-query-name').removeClass('error');
    $('#saveAs').modal('hide');
  } else if (viewModel.query.name()) {
    $.jHueNotify.error("${_('No query provided to save.')}");
    $('#saveAs').modal('hide');
  } else {
    $('#saveas-query-name').addClass('error');
  }
}

function saveAsModal() {
  var query = getHighlightedQuery() || codeMirror.getValue();
  viewModel.query.query(query);
  $('#saveAs').modal('show');
}


// Querying and click events.
function tryExecuteQuery() {
  $(".tooltip").remove();
  var query = getHighlightedQuery() || codeMirror.getValue();
  viewModel.query.query(query);
  if (viewModel.query.isParameterized()) {
    viewModel.fetchParameters();
  } else {
    viewModel.executeQuery();
  }
}

function tryExecuteParameterizedQuery() {
  $(".tooltip").remove();
  viewModel.executeQuery();
  routie('query');
}
;

function tryExplainQuery() {
  $(".tooltip").remove();
  var query = getHighlightedQuery() || codeMirror.getValue();
  viewModel.query.query(query);
  viewModel.explainQuery();
}

function tryExplainParameterizedQuery() {
  $(".tooltip").remove();
  viewModel.explainQuery();
  routie('query');
}
;

function tryCancelQuery() {
  $(".tooltip").remove();
  viewModel.cancelQuery();
}

function checkLastDatabase(server, database) {
  var key = "hueBeeswaxLastDatabase-" + server;
  if (database != $.totalStorage(key)) {
    $.totalStorage(key, database);
  }
}

function getLastDatabase(server) {
  var key = "hueBeeswaxLastDatabase-" + server;
  return $.totalStorage(key);
}


// Knockout
function clickHard(el) {
  var timer = setInterval(function () {
    if ($(el).length > 0) {
      $(el).click();
      clearInterval(timer);
    }
  }, 100);
}

viewModel = new BeeswaxViewModel("${app_name}", ${design.id and design.id or -1});
viewModel.fetchDatabases();
if (viewModel.query.id() > 0) {
  viewModel.query.query.subscribe((function () {
    // First call skipped to avoid reset of hueBeeswaxLastDatabase
    var counter = 0;
    return function (value) {
      if (counter++ == 0) {
        codeMirror.setValue(value);
      }
    }
  })());
  viewModel.fetchQuery();
}
ko.applyBindings(viewModel);

// Server error handling.
$(document).on('server.error', function (e, data) {
  $(document).trigger('error', "${_('Server error occured: ')}" + data.error);
});
$(document).on('server.unmanageable_error', function (e, responseText) {
  $(document).trigger('error', "${_('Unmanageable server error occured: ')}" + responseText);
});

// Other
$(document).on('saved.query', function (e) {
  $(document).trigger('info', "${'Query saved.'}");
});
$(document).on('error_cancel.query', function (e, message) {
  $(document).trigger("error", "${ _('Problem: ') }" + message);
});
$(document).on('cancelled.query', function (e) {
  $(document).trigger("info", "${ _('Query canceled!') }")
});

$(document).ready(function () {
  $("*[rel=tooltip]").tooltip({
    placement: 'bottom'
  });

  // hack for select default rendered fields
  $("select").addClass("input-medium");

  function getFileBrowseButton(inputElement) {
    return $("<button>").addClass("btn").addClass("fileChooserBtn").text("..").click(function (e) {
      e.preventDefault();
      $("#filechooser").jHueFileChooser({
        initialPath: inputElement.val(),
        onFileChoose: function (filePath) {
          inputElement.val(filePath);
          $("#chooseFile").modal("hide");
        },
        createFolder: false
      });
      $("#chooseFile").modal("show");
    })
  }

  // Type ahead for settings.
  $.getJSON("${ url(app_name + ':configuration') }", function (data) {
    $(".settingsField").typeahead({
      source: $.map(data.config_values, function (value, key) {
        return value.key;
      })
    });
  });

  // Help.
  $("#help").popover({
    'title': "${_('Did you know?')}",
    'content': $("#help-content").html(),
    'trigger': 'hover',
    'html': true
  });

  % if app_name == 'impala':
    $("#downloadQuery").click(function () {
      $("<input>").attr("type", "hidden").attr("name", "button-submit").attr("value", "Execute").appendTo($("#advancedSettingsForm"));
      $("<input>").attr("type", "hidden").attr("name", "download").attr("value", "true").appendTo($("#advancedSettingsForm"));
      tryExecuteQuery();
    });
  % endif

  % if app_name == 'impala':
    $("#refresh-dyk").popover({
      'title': "${_('Missing some tables? In order to update the list of tables/metadata seen by Impala, execute one of these queries:')}",
      'content': $("#refresh-content").html(),
      'trigger': 'hover',
      'html': true
    });

    $("#refresh-tip").popover({
      'title': "${_('Missing some tables? In order to update the list of tables/metadata seen by Impala, execute one of these queries:')}",
      'content': $("#refresh-content").html(),
      'trigger': 'hover',
      'html': true
    });
  % endif
});


// Routie
$(document).ready(function () {
  routie({
    'query': function () {
      showSection('query-editor');
      $('.resultsContainer').hide();
      codeMirror.setSize("95%", $(window).height() - 270 - $("#queryPane .alert-error").outerHeight() - $(".nav-tabs").outerHeight());
    },
    'query/execute/params': function () {
      if (viewModel.query.parameters().length == 0) {
        routie('query');
      }
      showSection('execute-parameter-selection');
    },
    'query/explain/params': function () {
      if (viewModel.query.parameters().length == 0) {
        routie('query');
      }
      showSection('explain-parameter-selection');
    },
    'query/logs': function () {
      if (viewModel.logs().length == 0) {
        routie('query');
      }
      codeMirror.setSize("95%", 100);
      $('.resultsContainer').show();
      $('.resultsContainer .watch-query').show();
      $('.resultsContainer .view-query-results').hide();
      clickHard('.resultsContainer .nav-tabs a[href="#log"]');
    },
    'query/results': function () {
      if (viewModel.resultsEmpty()) {
        routie('query');
      } else {
        codeMirror.setSize("95%", 100);
        $('.resultsContainer').show();
        $('.resultsContainer .watch-query').hide();
        $('.resultsContainer .view-query-results').show();
        clickHard('.resultsContainer .nav-tabs a[href="#results"]');
      }
    },
    'query/explanation': function () {
      if (!viewModel.explanation()) {
        routie('query');
      }
      codeMirror.setSize("95%", 100);
      $('.resultsContainer').show();
      $('.resultsContainer .watch-query').hide();
      $('.resultsContainer .view-query-results').show();
      clickHard('.resultsContainer .nav-tabs a[href="#explanation"]');
    },
    '': function () {
      routie('query');
    }
  });
  $(document).on('fetched.parameters', function () {
    if (viewModel.query.parameters().length > 0) {
      routie('query/execute/params');
    } else {
      viewModel.executeQuery();
    }
  });
  $(document).on('explained.query', function () {
    routie('query/explanation');
  });
  $(document).on('watched.query', function () {
    routie('query/logs');
  });
  $(document).on('fetched.results', function () {
    routie('query/results');
  });
});

// @TODO: Make file resources list automatically generated.
// @TODO: Improve resize logs to be more relative. See FF versus Chrome.
// @TODO: Close
// @TODO: Stop operation
// @TODO: Re-add filebrowser to file resources.
// @TODO: Re-add tooltips for execute query button
// @TODO: Re-add download query for impala
// @TODO: Re-enable type ahead for settings
</script>

${ commonfooter(messages) | n,unicode }
