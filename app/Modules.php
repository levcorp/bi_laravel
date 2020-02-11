<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Modules extends Model
{
    use SoftDeletes;
    private $table='modules';
    private $fillable=[
        'name',
        'descripction',
        'sub_module'
    ];
    protected $dateFormat = 'Y-d-m H:i.u';
    
    public function getDateFormat()
    {
        return 'Y-m-d H:i:s.u';
    }
}
