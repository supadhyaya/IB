<?php
include_once('UniDecoder.php');
require_once('conn.php');

class Slugifier
{
    
    protected static $defaultUniDecoder;

    protected $uniDecoder;

    public function slugify($string)
    {
        $string = $this->uniDecoder()->decode($string);
        $string = strtolower($string);
        $string = str_replace("'", '', $string);
        $string = preg_replace('([^a-zA-Z0-9_-]+)', '-', $string);
        $string = preg_replace('(-{2,})', '-', $string);
        $string = trim($string, '-');

        return $string;
    }

    public function uniDecoder()
    {
        if ($this->uniDecoder === null) {
            if (self::$defaultUniDecoder === null) {
                self::$defaultUniDecoder = new UniDecoder();
            }

            $this->uniDecoder = self::$defaultUniDecoder;
        }

        return $this->uniDecoder;
    }

    public function setUniDecoder(UniDecode $decoder)
    {
        $this->uniDecoder = $decoder;
    }

    public static function setDefaultUniDecoder(UniDecode $decoder)
    {
        self::$defaultUniDecoder = $decoder;
    }
}


