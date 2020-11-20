/*
 * xnat-template: org.nrg.xnat.plugins.template.rest.TemplateApi
 * XNAT http://www.xnat.org
 * Copyright (c) 2017, Washington University School of Medicine
 * All Rights Reserved
 *
 * Released under the Simplified BSD.
 */

package org.nrg.xnat.plugins.clinicaltrials.rest;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.nrg.framework.annotations.XapiRestController;
import org.nrg.xapi.rest.AbstractXapiRestController;
import org.nrg.xapi.rest.XapiRequestMapping;
import org.nrg.xdat.security.services.RoleHolder;
import org.nrg.xdat.security.services.UserManagementServiceI;
import org.nrg.xnat.plugins.clinicaltrials.entities.clinicalTrials;
import org.nrg.xnat.plugins.clinicaltrials.services.clinicalTrialsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;

@Api(description = "XNAT 1.7 clinicalTrials Plugin API")
@XapiRestController
@RequestMapping(value = "/clinicaltrials/entities")
public class clinicalTrialsApi extends AbstractXapiRestController {
    @Autowired
    protected clinicalTrialsApi(final UserManagementServiceI userManagementService, final RoleHolder roleHolder, final clinicalTrialsService templateService) {
        super(userManagementService, roleHolder);
        _templateService = templateService;
    }

    @ApiOperation(value = "Returns a list of all templates.", response = clinicalTrials.class, responseContainer = "List")
    @ApiResponses({@ApiResponse(code = 200, message = "clinicalTrialss successfully retrieved."),
                   @ApiResponse(code = 401, message = "Must be authenticated to access the XNAT REST API."),
                   @ApiResponse(code = 500, message = "Unexpected error")})
    @XapiRequestMapping(produces = {MediaType.APPLICATION_JSON_VALUE}, method = RequestMethod.GET)
    public ResponseEntity<List<clinicalTrials>> getEntities() {
        return new ResponseEntity<>(_templateService.getAll(), HttpStatus.OK);
    }

    @ApiOperation(value = "Creates a new template.", response = clinicalTrials.class)
    @ApiResponses({@ApiResponse(code = 200, message = "clinicalTrials successfully created."),
                   @ApiResponse(code = 401, message = "Must be authenticated to access the XNAT REST API."),
                   @ApiResponse(code = 500, message = "Unexpected error")})
    @XapiRequestMapping(produces = {MediaType.APPLICATION_JSON_VALUE}, method = RequestMethod.POST)
    public ResponseEntity<clinicalTrials> createEntity(@RequestBody final clinicalTrials entity) {
        final clinicalTrials created = _templateService.create(entity);
        return new ResponseEntity<>(created, HttpStatus.OK);
    }

    @ApiOperation(value = "Retrieves the indicated template.",
                  notes = "Based on the template ID, not the primary key ID.",
                  response = clinicalTrials.class)
    @ApiResponses({@ApiResponse(code = 200, message = "clinicalTrials successfully retrieved."),
                   @ApiResponse(code = 401, message = "Must be authenticated to access the XNAT REST API."),
                   @ApiResponse(code = 500, message = "Unexpected error")})
    @XapiRequestMapping(value = "{id}", produces = {MediaType.APPLICATION_JSON_VALUE}, method = RequestMethod.GET)
    public ResponseEntity<clinicalTrials> getEntity(@PathVariable final String id) {
        return new ResponseEntity<>(_templateService.findByTemplateId(id), HttpStatus.OK);
    }

    @ApiOperation(value = "Updates the indicated template.",
                  notes = "Based on primary key ID, not subject or record ID.",
                  response = Void.class)
    @ApiResponses({@ApiResponse(code = 200, message = "clinicalTrials successfully updated."),
                   @ApiResponse(code = 401, message = "Must be authenticated to access the XNAT REST API."),
                   @ApiResponse(code = 500, message = "Unexpected error")})
    @XapiRequestMapping(value = "{id}", produces = {MediaType.APPLICATION_JSON_VALUE}, method = RequestMethod.PUT)
    public ResponseEntity<Void> updateEntity(@PathVariable final Long id, @RequestBody final clinicalTrials entity) {
        final clinicalTrials existing = _templateService.retrieve(id);
        existing.setTemplateId(entity.getTemplateId());
        _templateService.update(existing);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @ApiOperation(value = "Deletes the indicated template.",
                  notes = "Based on primary key ID, not subject or record ID.",
                  response = Void.class)
    @ApiResponses({@ApiResponse(code = 200, message = "clinicalTrials successfully deleted."),
                   @ApiResponse(code = 401, message = "Must be authenticated to access the XNAT REST API."),
                   @ApiResponse(code = 500, message = "Unexpected error")})
    @XapiRequestMapping(value = "{id}", produces = {MediaType.APPLICATION_JSON_VALUE}, method = RequestMethod.DELETE)
    public ResponseEntity<Void> deleteEntity(@PathVariable final Long id) {
        final clinicalTrials existing = _templateService.retrieve(id);
        _templateService.delete(existing);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    private final clinicalTrialsService         _templateService;
}
