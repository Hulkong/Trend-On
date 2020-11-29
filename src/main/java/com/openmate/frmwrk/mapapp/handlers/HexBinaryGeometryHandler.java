package com.openmate.frmwrk.mapapp.handlers;

import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.WKBReader;

@MappedJdbcTypes(JdbcType.OTHER)
@MappedTypes({ Geometry.class })
public class HexBinaryGeometryHandler extends BaseTypeHandler<Geometry> {
	
	public HexBinaryGeometryHandler(){
	}

	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, Geometry parameter, JdbcType jdbcType)
			throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Geometry getNullableResult(ResultSet rs, String columnName) throws SQLException {
		if (rs == null) {
			return null;
		}
		InputStream binaryStream = rs.getBinaryStream(columnName);
		try {
			return getGeometryFromInputStream(binaryStream);
		} catch (Exception e1) {
			e1.printStackTrace();
			return null;
		}
	}

	@Override
	public Geometry getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		System.out.println("2getNullableResult"+columnIndex);
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Geometry getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
		System.out.println("3getNullableResult"+columnIndex);
		// TODO Auto-generated method stub
		return null;
	}
    private Geometry getGeometryFromInputStream(InputStream inputStream) throws Exception {
        Geometry dbGeometry = null;
        if(inputStream != null) {
        	StringBuffer sb = new StringBuffer();
            byte[] b = new byte[4096];
            for (int n; (n = inputStream.read(b)) != -1;)
                sb.append(new String(b, 0, n));
        	
            WKBReader wkbReader = new WKBReader();
            dbGeometry = wkbReader.read(WKBReader.hexToBytes(sb.toString()));
        }

        return dbGeometry;
    }
}
