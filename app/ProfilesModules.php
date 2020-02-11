<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ProfilesModules extends Model
{
    use SoftDeletes;
    protected $table='profiles_modules';
    protected $fillable=[
        'profile_id',
        'module_id',
        'create',
        'delete',
        'edit'
    ];
    protected $dateFormat = 'Y-d-m H:i.u';
    
    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
}
