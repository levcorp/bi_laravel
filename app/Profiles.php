<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Profiles extends Model
{
    use SoftDeletes;  

    protected $table='profiles';

    protected $fillable=[
        'name',
        'description'
    ];
    protected $dateFormat = 'Y-d-m H:i.u';
    
    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
}
