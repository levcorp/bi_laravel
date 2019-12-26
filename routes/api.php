<?php

Route::middleware(['cors'])->namespace('JWT')->prefix('auth')->group(function () {
    // Below mention routes are public, user can access those without any restriction.
    // Create New User
    Route::post('register', 'AuthController@register');
    // Login User
    Route::post('login', 'AuthController@login');
    
    // Refresh the JWT Token
    Route::get('refresh', 'AuthController@refresh');
    
    // Below mention routes are available only for the authenticated users.
    Route::middleware(['auth','cors'])->group(function () {
        // Get user info
        Route::get('user', 'AuthController@user');
        // Logout user from application
        Route::post('logout', 'AuthController@logout');
    });
});
