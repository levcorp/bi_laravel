<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->string('lastname');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->string('ci');
            $table->string('job');
            $table->string('state');
            $table->string('phone');
            $table->string('job_phone');
            $table->string('departament');
            $table->string('photo');
            $table->unsignedBigInteger('profile_id');
            $table->unsignedBigInteger('branch_office_id');
            $table->rememberToken();
            $table->timestamps();
            $table->softDeletes();
            $table->foreign('profile_id')->references('id')->on('profiles');
            $table->foreign('branch_office_id')->references('id')->on('branch_offices');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
